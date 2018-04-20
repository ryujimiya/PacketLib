package livefan.packet
{
    import flash.utils.ByteArray;

    /**
     * 
     * @author Owner
     */
    public class PppPacket extends Packet
    {
        private static const ProtocolLength:int = 2;
        
        private var _protocol:uint;
        
        public function PppPacket(byteAry:ByteArray, offset:int, parentPacket:Packet) 
        {
            super(byteAry, offset, parentPacket);
            init();
        }
        
        private function init():void 
        {
            var protocolPos:int = this._offset;
            
            this._headerLength = ProtocolLength;
            this._protocol = NetworkByteOrder.bufToUshort(this._byteAry, protocolPos);            
        }
		
        public override function get payloadPacket():Packet
        {
			if (_payloadPacket == null)
			{
                //var payloadByteAry:ByteArray = this.payloadByteAry;
                //this._payloadPacket = _parsePayloadByteAry(payloadByteAry, 0, this._protocol, this);
                // ペイロードデータを作成しないでペイロードパケットを作成する
                var payloadStPos:int = this._offset + this._headerLength;
                _payloadPacket = _parsePayloadByteAry(this._byteAry, payloadStPos, this._protocol, this);
			}
            return _payloadPacket;
        }
        
        private static function _parsePayloadByteAry(byteAry:ByteArray, offset:int, protocol:uint, parentPacket:Packet):Packet
        {
            var payloadPacket:Packet = null;
            
            if (protocol == PppProtocol.Ipv4)
            {
                payloadPacket = new Ipv4Packet(byteAry, offset, parentPacket);
            }
            else
            {
                trace("PppPacket not implemented protocol:" + protocol.toString());
                payloadPacket = null;
            }
            
            return payloadPacket;
        }
        
        public function get protocol():uint 
        {
            return _protocol;
        }
        
    }

}