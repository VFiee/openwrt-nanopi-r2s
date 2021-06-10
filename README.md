## R2S 基于原生 OpenWRT 的固件(AS IS, NO WARRANTY!!!)

[![R2S-OpenWrt](https://github.com/VFiee/openwrt-nanopi-r2s/workflows/R2S-OpenWrt/badge.svg)](https://github.com/VFiee/openwrt-nanopi-r2s/actions/workflows/R2S-OpenWrt.yml)  
[![X86-OpenWrt](https://github.com/VFiee/openwrt-nanopi-r2s/workflows/X86-OpenWrt/badge.svg)](https://github.com/VFiee/openwrt-nanopi-r2s/actions/workflows/X86-OpenWrt.yml)

### 请勿用于商业用途!!! 请勿用于商业用途!!! 请勿用于商业用途!!! 请勿用于商业用途!!! 请勿用于商业用途!!!

### 下载地址：

https://github.com/VFiee/openwrt-nanopi-r2s/releases

### 追新党可以在 Action 中取每日更新（可能会翻车，风险自担，需要登陆 github 后才能下载）：

https://github.com/VFiee/openwrt-nanopi-r2s/actions

### 注意事项：

0.R2S 核心频率 1.6

1.登陆 IP：192.168.2.1 密码：无

2.OP 内置升级可用

3.遇到上不了网的，请自行排查自己的 ipv6 联通情况。（推荐关闭 ipv6，默认已关闭 ipv6 的 dns 解析，手动可以在 DHCP/DNS 里的高级设置中调整）

4.刷写或升级后遇到任何问题，可以尝试 ssh 进路由器，输入 fuck，回车后等待重启，或可解决，如仍有异常，建议 ssh 进路由器，输入 firstboot -y && reboot now，回车后等待重启

### 版本信息：

LUCI 版本：21.02（当日最新）

其他模块版本：21.02（当日最新）

### 特性及功能：

1.O2 编译

2.内置两款主题

3.首次启动会自动分配 TF 卡剩余空间至 Overlay

4.插件包含：Npc, iperf3, MosDns, DiskMan, DockerMan, OpenClash, AdguardHome, BearDropper, 微信推送, 网易云解锁, SQM, 网络唤醒, DDNS, 迅雷快鸟, UPNP, FullCone(防火墙中开启, 默认开启), 流量分载(防火墙中开启), SFE 流量分载(也就是 SFE 加速, 防火墙中开启, 且默认开启), BBR（默认开启）, irq 优化, 京东签到, Zerotie, 无线打印, 流量监控, 过滤军刀
