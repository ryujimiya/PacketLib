package livefan.packet
{
    import flash.utils.ByteArray;
    
    /**
     * 
     * @author Owner
     */
    public class EthernetPacket extends Packet
    {
        private static const TypeLength:int = 2;
        private static const MacAddressLength:int = 6;
        
        private var _dstMacAddress:ByteArray;
        private var _srcMacAddress:ByteArray;
        private var _type:uint;
        
        public function EthernetPacket(byteAry:ByteArray, offset:int, parentPacket:Packet) 
        {
            super(byteAry, offset, parentPacket);
            init();
        }
        
        private function init():void
        {
            var dstMacPos:int = this._offset;
            var srcMacPos:int = dstMacPos + MacAddressLength;
            var typePos:int = srcMacPos + MacAddressLength;

            this._headerLength = typePos + TypeLength - this._offset;
            
            this._dstMacAddress = PacketUtil.newByteArray(this._byteAry, dstMacPos, MacAddressLength);
            this._srcMacAddress = PacketUtil.newByteArray(this._byteAry, srcMacPos, MacAddressLength);
            this._type = NetworkByteOrder.bufToUshort(byteAry, typePos);
            //trace(this._type.toString() + "  0x" + this._type.toString(16));
        }
        
        public override function get payloadPacket():Packet
        {
			if (_payloadPacket == null)
			{
                //var payloadbyteAry:ByteArray = this.payloadByteAry;
                //this._payloadPacket = _parsePayloadByteAry(payloadbyteAry, 0, this._type, this);
                // ペイロードデータを作成しないでペイロードパケットを作成する
                var payloadStPos:int = this._offset + this._headerLength;
                _payloadPacket = _parsePayloadByteAry(this._byteAry, payloadStPos, this._type, this);
			}
			return _payloadPacket;
        }

        private static function _parsePayloadByteAry(byteAry:ByteArray, offset:int, type:uint, parentPacket:Packet):Packet
        {
            var payloadPacket:Packet = null;
            
            if (type == EthernetPacketType.PointToPointProtocolOverEthernetSessionStage)
            {
                payloadPacket = new PppoePacket(byteAry, offset, parentPacket);
            }
            else if (type == EthernetPacketType.Ipv4)
            {
                payloadPacket = new Ipv4Packet(byteAry, offset, parentPacket);
            }
            else if (type == EthernetPacketType.Ipv6)
            {
                payloadPacket = new Ipv6Packet(byteAry, offset, parentPacket);
            }
            else
            {
                trace("EthernetPacket not implemented type:" + type.toString());
                payloadPacket = null;
            }
            return payloadPacket;
        }
        
        public function get dstMacAddress():ByteArray 
        {
            return _dstMacAddress;
        }
        
        public function get srcMacAddress():ByteArray 
        {
            return _srcMacAddress;
        }
        
        public function get type():uint 
        {
            return _type;
        }
        
    }

}