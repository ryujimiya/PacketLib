package livefan.packet
{
	import flash.utils.ByteArray;
	
	/**
     * ...
     * @author Owner
     */
    public class Ipv4Packet extends IpPacket 
    {
        private static const VersionHeaderLenLength:int = 1;
        private static const ServiceLength:int = 1;
        private static const TotalLenLength:int = 2;
        private static const IdLenLength:int = 2;
        private static const FlagsFragmentOffsetLength:int = 2;
        private static const TtlLength:int = 1;
        private static const ProtocolLength:int = 1;
        private static const ChecksumLength:int = 2;
        private static const AddressLength:int = 4;
        
        private var _version:uint;
        private var _headerLen:uint; // 32bit単位のヘッダ長
        private var _differentiatedServices:uint;
        private var _totalLen:uint;
        private var _Id:uint;
        private var _flags:uint;
        private var _fragmentOffset:uint;
        private var _ttl:uint;
        private var _protocol:uint;
        private var _checksum:uint;
        private var _srcAddress:ByteArray;
        private var _srcAddressAsUint:uint;
        private var _dstAddress:ByteArray;
        private var _dstAddressAsUint:uint;
        
        public function Ipv4Packet(byteAry:ByteArray, offset:int, parentPacket:Packet)
        {
            super(byteAry, offset, parentPacket);
            init();
        }
        
        private function init():void
        {
            var versionHeadLenPos:int = this._offset;
            var servicePos:int = versionHeadLenPos + VersionHeaderLenLength;
            var totalLenPos:int = servicePos + ServiceLength;
            var idPos:int = totalLenPos + TotalLenLength;
            var flagsFragmentOffsetPos:int = idPos + IdLenLength;
            var ttlPos:int = flagsFragmentOffsetPos + FlagsFragmentOffsetLength;
            var protocolPos:int = ttlPos + TtlLength;
            var checksumPos:int = protocolPos + ProtocolLength;
            var srcAddressPos:int = checksumPos + ChecksumLength;
            var dstAddressPos:int = srcAddressPos + AddressLength;
            
            var versionHeader:uint = this._byteAry[versionHeadLenPos];
            this._version = ((versionHeader >> 4) & 0xF);
            this._headerLen = (versionHeader & 0xF);
            this._differentiatedServices = this._byteAry[servicePos];
            this._totalLen = NetworkByteOrder.bufToUshort(this._byteAry, totalLenPos);
            this._Id = NetworkByteOrder.bufToUshort(this._byteAry, idPos);
            var flagsFragmentOffset:uint = NetworkByteOrder.bufToUshort(this._byteAry, flagsFragmentOffsetPos);
            this._flags = ((flagsFragmentOffset >> 13) & 0x7); // 3bit
            this._fragmentOffset = (flagsFragmentOffset & 0x1FFF); // 13bit
            this._ttl = this._byteAry[ttlPos];
            this._protocol = this._byteAry[protocolPos];
            this._checksum = NetworkByteOrder.bufToUshort(this._byteAry, checksumPos);
            this._srcAddress = PacketUtil.newByteArray(this._byteAry, srcAddressPos, AddressLength);
            this._srcAddressAsUint = NetworkByteOrder.bufToUint(this._byteAry, srcAddressPos);
            this._dstAddress = PacketUtil.newByteArray(this._byteAry, dstAddressPos, AddressLength);
            this._dstAddressAsUint = NetworkByteOrder.bufToUint(this._byteAry, dstAddressPos);

            this._headerLength = this._headerLen * 4;            
        }
        
        public override function get payloadPacket():Packet
        {
			if (_payloadPacket == null)
			{
                //var payloadByteAry:ByteArray = this.payloadByteAry;
                //this._payloadPacket = IpPacket._parsePayloadByteAry(payloadByteAry, 0, this._protocol, this);
                // ペイロードデータを作成しないでペイロードパケットを作成する
                var payloadStPos:int = this._offset + this._headerLength;
                _payloadPacket = IpPacket._parsePayloadByteAry(this._byteAry, payloadStPos, this._protocol, this);
			}
			return _payloadPacket;
        }

        public function get version():uint 
        {
            return _version;
        }
        
        public function get headerLen():uint 
        {
            return _headerLen;
        }
        
        public function get differentiatedServices():uint 
        {
            return _differentiatedServices;
        }
        
        public function get totalLen():uint 
        {
            return _totalLen;
        }
        
        public function get Id():uint 
        {
            return _Id;
        }
        
        public function get flags():uint 
        {
            return _flags;
        }
        
        public function get fragmentOffset():uint 
        {
            return _fragmentOffset;
        }
        
        public function get ttl():uint 
        {
            return _ttl;
        }
        
        public function get protocol():uint 
        {
            return _protocol;
        }
        
        public function get checksum():uint 
        {
            return _checksum;
        }
        
        public function get srcAddress():ByteArray
        {
            return _srcAddress;
        }
        
        public function get srcAddressAsUint():uint 
        {
            return _srcAddressAsUint;
        }
        
        public function get dstAddress():ByteArray
        {
            return _dstAddress;
        }
        
        public function get dstAddressAsUint():uint 
        {
            return _dstAddressAsUint;
        }
        
    }

}