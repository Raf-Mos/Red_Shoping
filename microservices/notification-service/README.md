# Notification Service

Python/Flask microservice for asynchronous notifications using RabbitMQ.

## Features

- ✅ **Event-Driven** - Listens to RabbitMQ events
- ✅ **Email Notifications** - Order confirmations, cancellations, status updates
- ✅ **Async Processing** - Non-blocking notification delivery
- ✅ **Mock Email** - Console logging in development
- ✅ **Production Ready** - Easy to integrate with SMTP, SendGrid, AWS SES

## Environment Variables

```env
FLASK_ENV=development
PORT=8004
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
RABBITMQ_QUEUE=notifications
SMTP_HOST=localhost
SMTP_PORT=1025
FROM_EMAIL=noreply@redshopping.com
```

## Event Types

The service listens to these events:

### 1. Order Created
```json
{
  "event_type": "order_created",
  "order_id": 1,
  "user_email": "user@example.com",
  "total": 1299.99,
  "items": [
    {
      "product_name": "Laptop",
      "quantity": 1,
      "subtotal": 1299.99
    }
  ]
}
```
**Action**: Sends order confirmation email

### 2. Order Cancelled
```json
{
  "event_type": "order_cancelled",
  "order_id": 1,
  "user_email": "user@example.com",
  "total": 1299.99
}
```
**Action**: Sends cancellation confirmation email

### 3. Order Status Updated
```json
{
  "event_type": "order_status_updated",
  "order_id": 1,
  "user_email": "user@example.com",
  "status": "shipped"
}
```
**Action**: Sends status update email

## Components

### Consumer (`consumer.py`)
- Listens to RabbitMQ queue
- Processes events asynchronously
- Calls email sender based on event type
- **This is the main process to run**

### Web API (`app.py`)
- Optional Flask API for health checks
- Not required for core functionality

### Email Sender (`utils/email_sender.py`)
- Sends emails based on event type
- Mock implementation for development
- Easy to extend for production SMTP

## Development

### Start Consumer (Main Process)
```bash
# Install dependencies
pip install -r requirements.txt

# Start the consumer
python src/consumer.py
```

The consumer will:
1. Connect to RabbitMQ
2. Listen to the `notifications` queue
3. Process events and send emails
4. Log emails to console in development

### Start Web API (Optional)
```bash
python src/app.py
```

## Docker

```bash
docker build -t red-shopping-notification-service .
docker run red-shopping-notification-service
```

## Email Templates

### Order Confirmation
```
Subject: Order Confirmation - Order #123

Dear Customer,

Thank you for your order!

Order Details:
Order ID: #123
Total Amount: $1299.99

Items:
- Laptop x1 - $1299.99

Your order is being processed...
```

### Order Cancellation
```
Subject: Order Cancelled - Order #123

Dear Customer,

Your order has been cancelled as requested.

Order ID: #123
Total Amount: $1299.99
```

### Status Update
```
Subject: Order Update - Order #123

Dear Customer,

Order Status Update:
Order ID: #123
New Status: SHIPPED

Your order has been shipped! It should arrive soon.
```

## Production Email Integration

To use real email sending, update `utils/email_sender.py`:

### With SMTP
```python
import smtplib
from email.mime.text import MIMEText

msg = MIMEText(body)
msg['Subject'] = subject
msg['From'] = FROM_EMAIL
msg['To'] = to_email

with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
    server.starttls()
    server.login(SMTP_USER, SMTP_PASSWORD)
    server.send_message(msg)
```

### With SendGrid
```python
import sendgrid
from sendgrid.helpers.mail import Mail

sg = sendgrid.SendGridAPIClient(api_key=SENDGRID_API_KEY)
message = Mail(from_email=FROM_EMAIL, to_emails=to_email, subject=subject, html_content=body)
response = sg.send(message)
```

## Monitoring

Check consumer logs:
```bash
docker logs -f red-shopping-notification-service
```

You'll see:
- 📨 Event received
- 📧 Email sent
- ✅ Success confirmations
- ❌ Error messages
