import json
import os
import sys
from utils.rabbitmq import get_rabbitmq_connection, declare_queue
from utils.email_sender import (
    send_order_confirmation,
    send_order_cancelled,
    send_order_status_update
)

def process_event(ch, method, properties, body):
    """Process incoming event from RabbitMQ"""
    try:
        # Parse event
        event = json.loads(body)
        event_type = event.get('event_type')
        
        print(f"📨 Received event: {event_type}")
        
        # Handle different event types
        if event_type == 'order_created':
            send_order_confirmation(
                user_email=event.get('user_email'),
                order_id=event.get('order_id'),
                total=event.get('total'),
                items=event.get('items', [])
            )
            print(f"✅ Sent order confirmation for order #{event.get('order_id')}")
        
        elif event_type == 'order_cancelled':
            send_order_cancelled(
                user_email=event.get('user_email'),
                order_id=event.get('order_id'),
                total=event.get('total')
            )
            print(f"✅ Sent order cancellation for order #{event.get('order_id')}")
        
        elif event_type == 'order_status_updated':
            send_order_status_update(
                user_email=event.get('user_email'),
                order_id=event.get('order_id'),
                status=event.get('status')
            )
            print(f"✅ Sent status update for order #{event.get('order_id')}")
        
        else:
            print(f"⚠️  Unknown event type: {event_type}")
        
        # Acknowledge message
        ch.basic_ack(delivery_tag=method.delivery_tag)
        
    except json.JSONDecodeError as e:
        print(f"❌ Failed to parse event: {e}")
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=False)
    except Exception as e:
        print(f"❌ Error processing event: {e}")
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=True)

def start_consumer():
    """Start RabbitMQ consumer"""
    queue_name = os.getenv('RABBITMQ_QUEUE', 'notifications')
    
    print("🚀 Starting Notification Service Consumer")
    print(f"📬 Listening to queue: {queue_name}")
    
    try:
        # Connect to RabbitMQ
        connection = get_rabbitmq_connection()
        channel = connection.channel()
        
        # Declare queue
        declare_queue(channel, queue_name)
        
        # Set QoS - process one message at a time
        channel.basic_qos(prefetch_count=1)
        
        # Start consuming
        channel.basic_consume(
            queue=queue_name,
            on_message_callback=process_event,
            auto_ack=False
        )
        
        print("✅ Notification Service is ready")
        print("⏳ Waiting for messages. Press CTRL+C to exit.")
        
        channel.start_consuming()
        
    except KeyboardInterrupt:
        print("\n⚠️  Consumer interrupted by user")
        sys.exit(0)
    except Exception as e:
        print(f"❌ Consumer error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    start_consumer()
