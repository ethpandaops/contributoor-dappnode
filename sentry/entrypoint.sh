#!/bin/bash

ERROR="[ ERROR ]"
WARN="[ WARN ]"
INFO="[ INFO ]"

echo "${INFO} supervisord start"
exec supervisord -c /etc/supervisord/supervisord.conf