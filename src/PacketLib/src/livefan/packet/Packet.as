package livefan.packet
{
    import flash.utils.ByteArray;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    /**
     * 
     * @author Owner
     */
    public class Packet 
    {
        private static const DLT_EN10MB:int = 1;
        private static const DLT_PPP:int = 9;

        protected var _parentPacket:Packet;
        protected var _byteAry:ByteArray;
        protected var _offset:int;
        protected var _actualByteAry:ByteArray;
        protected var _headerLength:int;
        protected var _payloadByteAry:ByteArray;
        protected var _payloadPacket:Packet;
        
        /**
         * パケットデータをパケットオブジェクトに変換する
         * @param dataLinkType WinPcapのデータリンクタイプ値
         * @param byteAry パケットデータ
         * @return パケットオブジェクト
         */
        public static function parsePacket(dataLinkType:int, byteAry:ByteArray):Packet
        {
            var packet:Packet = null;
            
            if (dataLinkType == DLT_EN10MB) 
            {
                packet = new EthernetPacket(byteAry, 0, null);
            }
            else if (dataLinkType == DLT_PPP)
            {
                packet = new PppPacket(byteAry, 0, null);
            }
            else
            {
                packet = null;
            }
            return packet;
        }
        
        /**
         * コンストラクタ
         * @param byteAry
         * @param offset
         * @param parentPacket
         */
        public function Packet(byteAry:ByteArray, offset:int, parentPacket:Packet) 
        {
            this._parentPacket = parentPacket;
            this._byteAry = byteAry;
            this._offset = offset;
            this._actualByteAry = null;
            this._headerLength = 0;
            this._payloadByteAry = null;
            this._payloadPacket = null;
        }
        
        /**
         * オフセットのない実質のバイトアレイを作成する
         * @return
         */
        private function _newActualByteAry():ByteArray
        {
            var actualByteAry:ByteArray = null;
            if (this._offset == 0)
            {
                actualByteAry = this._byteAry;
            }
            else
            {
                var offset:int = this._offset;
                var len:int = this._byteAry.length - offset;
                actualByteAry = new ByteArray();
                actualByteAry.writeBytes(this._byteAry, offset, len);
                actualByteAry.position = 0;
            }
            return actualByteAry;
        }
        
        /**
         * ペイロードデータを作成する(headerLengthが指定済みであること)
         * @param byteAry
         */
        private function _newPayloadByteAry():ByteArray
        {
            if (this._headerLength == 0)
            {
                return null;
            }
            var offset:int = this._offset + this._headerLength;
            var len:int = this._byteAry.length - offset;
            var payloadByteAry:ByteArray = new ByteArray();
            payloadByteAry.writeBytes(this._byteAry, offset, len);
            payloadByteAry.position = 0;
            return payloadByteAry;
        }
                
        /**
         * 指定クラスのパケットを取り出す
         * @param chkClass
         * @return パケットオブジェクト
         */
        public function extractPacket(chkClass:Class):Packet 
        {
            var tgtPacket:Packet = null;
            for (var curPacket:Packet = this; curPacket != null; curPacket = curPacket.payloadPacket)
            {
                var curClassName:String = getQualifiedClassName(curPacket);
                var curClass:Class = getDefinitionByName(curClassName) as Class;
                if (curClass == chkClass)
                {
                    tgtPacket = curPacket;
                    break;
                }
            }
            return tgtPacket;
        }
        
        /**
         * 内包するパケットの一番内側にあるパケットを取得する
         * @return パケットオブジェクト
         */
        public function getLastPacket():Packet
        {
            var tgtPacket:Packet = null;
            for (var curPacket:Packet = this; curPacket != null; curPacket = curPacket.payloadPacket)
            {
                tgtPacket = curPacket;
            }
            return tgtPacket;
        }

        public function get parentPacket():Packet
        {
            return _parentPacket;
        }

        public function get byteAry():ByteArray 
        {
            return _byteAry;
        }

        public function get offset():int 
        {
            return _offset;
        }
        
        public function get actualByteAry():ByteArray
        {
            if (_actualByteAry == null)
            {
                _actualByteAry = _newActualByteAry();
            }
            return _actualByteAry;
        }

        public function get headerLength():int 
        {
            return _headerLength;
        }
        
        public function get payloadByteAry():ByteArray 
        {
            if (_payloadByteAry == null)
            {
                _payloadByteAry = _newPayloadByteAry();
            }
            return _payloadByteAry;
        }
        
        public function get payloadPacket():Packet 
        {
            return _payloadPacket;
        }
        
    }

}