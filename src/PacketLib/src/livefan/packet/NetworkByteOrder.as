package livefan.packet
{
    import flash.utils.ByteArray;

    /**
     * 
     * @author Owner
     */
    public class NetworkByteOrder 
    {
        public static function bufToUshort(byteAry:ByteArray, pos:int):uint
        {
            if (pos + 1 >= byteAry.length)
            {
                return 0;
            }
            return ((byteAry[pos] << 8) + byteAry[pos + 1]);
        }
        
        public static function bufToUint(byteAry:ByteArray, pos:int):uint
        {
            if (pos + 3 >= byteAry.length)
            {
                return 0;
            }
            return ((byteAry[pos] << 24) + (byteAry[pos + 1] << 16) + (byteAry[pos + 2] << 8) + byteAry[pos + 3]);
        }
    }

}