import os
from datetime import datetime

def send_email(to_email, subject, body):
    """
    Send email notification
    In development, this just logs the email
    In production, you would use SMTP, SendGrid, AWS SES, etc.
    """
    try:
        # Mock email sending for development
        if os.getenv('FLASK_ENV') == 'development':
            print("\n" + "="*60)
            print("📧 EMAIL NOTIFICATION")
            print("="*60)
            print(f"To: {to_email}")
            print(f"Subject: {subject}")
            print(f"Body:\n{body}")
            print(f"Sent at: {datetime.utcnow().isoformat()}")
            print("="*60 + "\n")
            return True
        
        # Production email sending would go here
        # Example with SMTP:
        # import smtplib
        # from email.mime.text import MIMEText
        # 
        # msg = MIMEText(body)
        # msg['Subject'] = subject
        # msg['From'] = os.getenv('FROM_EMAIL')
        # msg['To'] = to_email
        # 
        # with smtplib.SMTP(os.getenv('SMTP_HOST'), os.getenv('SMTP_PORT')) as server:
        #     server.starttls()
        #     server.login(os.getenv('SMTP_USER'), os.getenv('SMTP_PASSWORD'))
        #     server.send_message(msg)
        
        return True
    except Exception as e:
        print(f"❌ Failed to send email: {e}")
        return False

def send_order_confirmation(user_email, order_id, total, items):
    """Send order confirmation email"""
    subject = f"Order Confirmation - Order #{order_id}"
    
    items_text = "\n".join([
        f"- {item['product_name']} x{item['quantity']} - ${item['subtotal']:.2f}"
        for item in items
    ])
    
    body = f"""
Dear Customer,

Thank you for your order!

Order Details:
Order ID: #{order_id}
Total Amount: ${total:.2f}

Items:
{items_text}

Your order is being processed and you will receive another email when it ships.

Thank you for shopping with Red Shopping!

Best regards,
The Red Shopping Team
    """
    
    return send_email(user_email, subject, body)

def send_order_cancelled(user_email, order_id, total):
    """Send order cancellation email"""
    subject = f"Order Cancelled - Order #{order_id}"
    
    body = f"""
Dear Customer,

Your order has been cancelled as requested.

Order Details:
Order ID: #{order_id}
Total Amount: ${total:.2f}

If you did not request this cancellation, please contact our support team immediately.

Best regards,
The Red Shopping Team
    """
    
    return send_email(user_email, subject, body)

def send_order_status_update(user_email, order_id, status):
    """Send order status update email"""
    subject = f"Order Update - Order #{order_id}"
    
    status_messages = {
        'confirmed': 'Your order has been confirmed and is being prepared.',
        'shipped': 'Your order has been shipped! It should arrive soon.',
        'delivered': 'Your order has been delivered. Thank you for shopping with us!',
        'cancelled': 'Your order has been cancelled.'
    }
    
    message = status_messages.get(status, f'Your order status has been updated to: {status}')
    
    body = f"""
Dear Customer,

Order Status Update:

Order ID: #{order_id}
New Status: {status.upper()}

{message}

Track your order anytime by logging into your account.

Best regards,
The Red Shopping Team
    """
    
    return send_email(user_email, subject, body)
