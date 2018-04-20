@echo off
set PAUSE_ERRORS=1
call bat\SetupSDK.bat

:::call acompc -load-config library.xml
call acompc -target-player=13 ^
   -source-path src ^
   -include-classes ^
       livefan.packet.EthernetPacket ^
       livefan.packet.EthernetPacketType ^
       livefan.packet.IpPacket ^
       livefan.packet.IpProtocolType ^
       livefan.packet.Ipv4Packet ^
       livefan.packet.Ipv6Packet ^
       livefan.packet.NetworkByteOrder ^
       livefan.packet.Packet ^
       livefan.packet.PacketUtil ^
       livefan.packet.PppoePacket ^
       livefan.packet.PppPacket ^
       livefan.packet.PppProtocol ^
       livefan.packet.TcpCtrlFlag ^
       livefan.packet.TcpPacket ^
       livefan.packet.UdpPacket ^
   -output=bin/PacketLib.swc
