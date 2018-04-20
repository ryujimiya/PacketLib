package livefan.packet
{
    import flash.utils.ByteArray;
    
    /**
     * 
     * @author Owner
     */
    public class TcpPacket extends Packet
    {
        private static const PortLength:int = 2;
        private static const SequenceNumberLength:int = 4;
        private static const AckNumberLength:int = 4;
        private static const DataOffsetLength:int = 1; // note:4bitのみ,後半4bitは予約
        private static const CtrlFlagsLength:int = 1; // note:後半6bitのみ,前半2bitは予約
        private static const WindowSizeLength:int = 2;
        private static const ChecksumLength:int = 2;
        private static const UrgentPointerLength:int = 2;
        
        private var _srcPort:uint;
        private var _dstPort:uint;
        private var _sequenceNumber:uint;
        private var _ackNumber:uint;
        private var _dataOffset:uint; // 32bit単位のヘッダ長
        private var _ctrlFlags:uint;
        private var _windowSize:uint;
        private var _checksum:uint;
        private var _urgentPointer:uint;
        
        public function TcpPacket(byteAry:ByteArray, offset:int, parentPacket:Packet)
        {
            super(byteAry, offset, parentPacket);
            init();
        }
        
        private function init():void 
        {
            var srcPortPos:int = this._offset;
            var dstPortPos:int = srcPortPos + PortLength;
            var sequenceNumberPos:int = dstPortPos + PortLength;
            var ackNumberPos:int = sequenceNumberPos + SequenceNumberLength;
            var dataOffsetPos:int = ackNumberPos + AckNumberLength;
            var ctrlFlagsPos:int = dataOffsetPos + DataOffsetLength;
            var windowSizePos:int = ctrlFlagsPos + CtrlFlagsLength;
            var checksumPos:int = windowSizePos + WindowSizeLength;
            var urgentPointerPos:int = checksumPos + ChecksumLength;
            
            this._srcPort = NetworkByteOrder.bufToUshort(this._byteAry, srcPortPos);
            this._dstPort = NetworkByteOrder.bufToUshort(this._byteAry, dstPortPos);
            this._sequenceNumber = NetworkByteOrder.bufToUint(this._byteAry, sequenceNumberPos);
            this._ackNumber = NetworkByteOrder.bufToUint(this._byteAry, ackNumberPos);
            this._dataOffset = ((this._byteAry[dataOffsetPos] >> 4) & 0xF);
            this._ctrlFlags = (this._byteAry[ctrlFlagsPos] & 0x3F); // 6bit
            this._windowSize = NetworkByteOrder.bufToUshort(this._byteAry, windowSizePos);
            this._checksum = NetworkByteOrder.bufToUshort(this._byteAry, checksumPos);
            this._urgentPointer = NetworkByteOrder.bufToUshort(this._byteAry, urgentPointerPos);

            this._headerLength = this._dataOffset * 4;
            
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
        
        public function get sequenceNumber():uint 
        {
            return _sequenceNumber;
        }
        
        public function get ackNumber():uint 
        {
            return _ackNumber;
        }
        
        public function get dataOffset():uint 
        {
            return _dataOffset;
        }
        
        public function get ctrlFlags():uint 
        {
            return _ctrlFlags;
        }
        
        public function get windowSize():uint 
        {
            return _windowSize;
        }
        
        public function get checksum():uint 
        {
            return _checksum;
        }
        
        public function get urgentPointer():uint 
        {
            return _urgentPointer;
        }
    
    }

}