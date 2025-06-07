# backup/cron/Dockerfile

FROM alpine

# Install PostgreSQL client and cron
RUN apk add --no-cache postgresql-client bash curl tzdata

# Set timezone (optional)
ENV TZ=UTC

# Copy backup script and make it executable
COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

# Add cron job (runs daily at 2 AM)
RUN echo "0 2 * * * /backup.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root

# Start cron in foreground
CMD ["crond", "-f"]
