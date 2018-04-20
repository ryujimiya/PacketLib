package livefan.packet
{
    import flash.utils.ByteArray;
    
    /**
     * 
     * @author Owner
     */
    public class UdpPacket extends Packet
    {
        private static const PortLength:int = 2;
        private static const LenLength:int = 2;
        private static const ChecksumLength:int = 2;
        
        private var _srcPort:uint;
        private var _dstPort:uint;
        private var _len:uint;
        private var _checksum:uint;
        
        public function UdpPacket(byteAry:ByteArray, offset:int, parentPacket:Packet)
        {
            super(byteAry, offset, parentPacket);
            init();
        }
        
        private function init():void 
        {
            var srcPortPos:int = this._offset;
            var dstPortPos:int = srcPortPos + PortLength;
            var lenPos:int = dstPortPos + PortLength;
            var checksumPos:int = lenPos + LenLength;
            
            this._headerLength = checksumPos + ChecksumLength - this._offset;
            this._srcPort = NetworkByteOrder.bufToUshort(this._byteAry, srcPortPos);
            this._dstPort = NetworkByteOrder.bufToUshort(this._byteAry, dstPortPos);
            this._len = NetworkByteOrder.bufToUshort(this._byteAry, lenPos);
            this._checksum = NetworkByteOrder.bufToUshort(this._byteAry, checksumPos);
            
            //var payloadByteAry:ByteArray = this.payloadByteAry;
            this._payloadPacket = null;
        }
        
        public function get srcPort():uint 
        {
            return _srcPort;
        }
        
        public function get dstPort():uint 
        {
            return _dstPort;
        }
        
        public function get len():uint 
        {
            return _len;
        }
        
        public function get checksum():uint 
        {
            return _checksum;
        }
    
    }

}