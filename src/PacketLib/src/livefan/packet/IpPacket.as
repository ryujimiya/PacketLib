package livefan.packet
{
    import flash.utils.ByteArray;
    
    /**
     * 
     * @author Owner
     */
    public class IpPacket extends Packet
    {
        
        public function IpPacket(byteAry:ByteArray, offset:int, parentPacket:Packet)
        {
            super(byteAry, offset, parentPacket);
        }
    
        protected static function _parsePayloadByteAry(byteAry:ByteArray, offset:int, protocol:uint, parentPacket:Packet):Packet 
        {
            var payloadPacket:Packet = null;

            if (protocol == IpProtocolType.TCP)
            {
                payloadPacket = new TcpPacket(byteAry, offset, parentPacket);
            }
            else if (protocol == IpProtocolType.UDP)
            {
                payloadPacket = new UdpPacket(byteAry, offset, parentPacket);
            }
            else
            {
                trace("IpPacket not implemented protocol:" + protocol.toString());
                payloadPacket = null;
            }
            
            return payloadPacket;
        }
    }

}