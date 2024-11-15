#!/bin/bash
# 定义连接 master 进行同步的账号
SLAVE_SYNC_USER="${SLAVE_SYNC_USER:-sync_admin}"
# 定义连接 master 进行同步的账号密码
SLAVE_SYNC_PASSWORD="${SLAVE_SYNC_PASSWORD:-123456}"
# 定义 slave 数据库账号
ADMIN_USER="${ADMIN_USER:-root}"
# 定义 slave 数据库密码
ADMIN_PASSWORD="${ADMIN_PASSWORD:-123456}"
# 定义连接 master 数据库的 host 地址
MASTER_HOST="${MASTER_HOST:-%}"
# 等待 10s，保证 master 数据库启动成功，不然会连接失败
sleep 10

# 连接 master 数据库，查询二进制数据，并解析出 logfile 和 pos
RESULT=$(mysql -u"$SLAVE_SYNC_USER" -h"$MASTER_HOST" -p"$SLAVE_SYNC_PASSWORD" -e "SHOW MASTER STATUS;" | tail -n +2 | awk '{print $1, $2}')

# 解析出 logfile 和 pos
LOG_FILE_NAME=$(echo $RESULT | awk '{print $1}')
LOG_FILE_POS=$(echo $RESULT | awk '{print $2}')

# 设置连接 master 的同步相关信息
SYNC_SQL="CHANGE MASTER TO MASTER_HOST='$MASTER_HOST', MASTER_USER='$SLAVE_SYNC_USER', MASTER_PASSWORD='$SLAVE_SYNC_PASSWORD', MASTER_LOG_FILE='$LOG_FILE_NAME', MASTER_LOG_POS=$LOG_FILE_POS;"

# 开启同步
START_SYNC_SQL="START SLAVE;"

# 查看同步状态
STATUS_SQL="SHOW SLAVE STATUS\G;"

# 执行 SQL
mysql -u"$ADMIN_USER" -p"$ADMIN_PASSWORD" -e "$SYNC_SQL"
mysql -u"$ADMIN_USER" -p"$ADMIN_PASSWORD" -e "$START_SYNC_SQL"
mysql -u"$ADMIN_USER" -p"$ADMIN_PASSWORD" -e "$STATUS_SQL"
