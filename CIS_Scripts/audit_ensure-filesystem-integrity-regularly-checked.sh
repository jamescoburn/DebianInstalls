#!/usr/bin/env bash

grep -Prs '^([^#\n\r]+\h+)?(\/usr\/s?bin\/|^\h*)aide(\.wrapper)?\h+(--check|([^#\n\r]+\h+)?\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/

systemctl is-enabled aidecheck.service
systemctl is-enabled aidecheck.timer
systemctl status aidecheck.timer