package livefan.packet
{
    import flash.utils.ByteArray;

    /**
     * 
     * @author Owner
     */
    public class PppoePacket extends Packet
    {
        private static const VersionTypeLength:int = 1;
        private static const CodeLength:int = 1;
        private static const SessionIdLength:int = 2;
        private static const LenLength:int = 2;

        private var _version:uint;
        private var _type:uint;
        private var _code:uint;
        private var _sessionId:uint;
        private var _len:uint;
        
        public function PppoePacket(byteAry:ByteArray, offset:int, parentPacket:Packet) 
        {
            super(byteAry, offset, parentPacket);
            init();
        }
        
        private function init():void 
        {
            var verPos:int = this._offset;
            var codePos:int = verPos + VersionTypeLength;
            var sessionPos:int = codePos + CodeLength;
            var lenPos:int = sessionPos + SessionIdLength;
            
            this._headerLength = lenPos + LenLength - this._offset;
            var versionType:uint = this._byteAry[verPos];
            this._version = ((versionType >> 4) & 0xF);
            this._type = (versionType & 0xF);
            this._code = byteAry[codePos];
            this._sessionId = NetworkByteOrder.bufToUshort(this._byteAry, sessionPos);
            this._len = NetworkByteOrder.bufToUshort(this._byteAry, lenPos);
        }

        public override function get payloadPacket():Packet
        {
			if (_payloadPacket == null)
			{
                //var payloadByteAry:ByteArray = this.payloadByteAry;
                //this._payloadPacket = _parsePayloadByteAry(payloadByteAry, 0, this);
                // ペイロードデータを作成しないでペイロードパケットを作成する
                var payloadStPos:int = this._offset + this._headerLength;
                _payloadPacket = _parsePayloadByteAry(this._byteAry, payloadStPos, this);
			}
			return _payloadPacket;
        }
        
        private static function _parsePayloadByteAry(byteAry:ByteArray, offset:int, parentPacket:Packet):Packet
        {
            var payloadPacket:Packet = null;
            
            payloadPacket = new PppPacket(byteAry, offset, parentPacket);
            
            return payloadPacket;
        }
                
        public function get version():uint 
        {
            return _version;
        }
        
        public function get type():uint 
        {
            return _type;
        }
        
        public function get code():uint 
        {
            return _code;
        }
        
        public function get sessionId():uint 
        {
            return _sessionId;
        }
        
        public function get len():uint 
        {
            return _len;
        }
        
    }

}