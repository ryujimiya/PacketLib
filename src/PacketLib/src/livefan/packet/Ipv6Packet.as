package livefan.packet
{
    import flash.utils.ByteArray;
    
    /**
     * 
     * @author Owner
     */
    public class Ipv6Packet extends IpPacket
    {
        private static const VersionTrafficClassFlowLabelLength:int = 4;
        private static const PayloadLenLength:int = 2;
        private static const NextHeaderLength:int = 1;
        private static const HopLimitLength:int = 1;
        private static const AddressLength:int = 16;
        
        private var _version:uint;
        private var _trafficClass:uint;
        private var _flowLabel:uint;
        private var _payloadLen:uint;
        private var _nextHeader:uint;
        private var _hopLimit:uint;
        private var _srcAddress:ByteArray;
        private var _dstAddress:ByteArray;
        
        public function Ipv6Packet(byteAry:ByteArray, offset:int, parentPacket:Packet)
        {
            super(byteAry, offset, parentPacket);
            init();
        }
        
        private function init():void
        {
            var versionTrafficClassFlowLabelPos:int = this._offset;
            var payloadLenPos:int = versionTrafficClassFlowLabelPos + VersionTrafficClassFlowLabelLength;
            var nextHeaderPos:int = payloadLenPos + PayloadLenLength;
            var hopLimitPos:int = nextHeaderPos + NextHeaderLength;
            var srcAddressPos:int = hopLimitPos + HopLimitLength;
            var dstAddressPos:int = srcAddressPos + AddressLength;
            
            var versionTrafficClassFlowLabel:uint = NetworkByteOrder.bufToUint(this._byteAry, versionTrafficClassFlowLabelPos);
            this._version = ((versionTrafficClassFlowLabel >> 28) & 0xF);
            this._trafficClass = ((versionTrafficClassFlowLabel >> 20) & 0xFF);
            this._flowLabel = (versionTrafficClassFlowLabel & 0xFFFFF); // 20bit
            this._payloadLen = NetworkByteOrder.bufToUshort(this._byteAry, payloadLenPos);
            this._nextHeader = this._byteAry[nextHeaderPos];
            this._hopLimit = this._byteAry[hopLimitPos];
            this._srcAddress = PacketUtil.newByteArray(this._byteAry, srcAddressPos, AddressLength);
            this._dstAddress = PacketUtil.newByteArray(this._byteAry, dstAddressPos, AddressLength);

            //this._headerLength = 40;
            //this._headerLength = dstAddressPos + AddressLength - this._offset;
            this._headerLength = this._byteAry.length - this._payloadLen - this._offset;
        }
        
        public override function get payloadPacket():Packet
        {
			if (_payloadPacket == null)
			{
                //var payloadByteAry:ByteArray = this.payloadByteAry;
                //this._payloadPacket = IpPacket._parsePayloadByteAry(payloadByteAry, 0, this._nextHeader, this);
                // ペイロードデータを作成しないでペイロードパケットを作成する
                var payloadStPos:int = this._offset + this._headerLength;
                _payloadPacket = IpPacket._parsePayloadByteAry(this._byteAry, payloadStPos, this._nextHeader, this);
			}
			return _payloadPacket;
        }

        public function get version():uint 
        {
            return _version;
        }
        
        public function get trafficClass():uint 
        {
            return _trafficClass;
        }
        
        public function get flowLabel():uint 
        {
            return _flowLabel;
        }
        
        public function get payloadLen():uint 
        {
            return _payloadLen;
        }
        
        public function get nextHeader():uint 
        {
            return _nextHeader;
        }
        
        public function get hopLimit():uint 
        {
            return _hopLimit;
        }
        
        public function get srcAddress():ByteArray 
        {
            return _srcAddress;
        }
        
        public function get dstAddress():ByteArray 
        {
            return _dstAddress;
        }
    }

}