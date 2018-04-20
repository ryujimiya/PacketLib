package livefan.packet
{
    import flash.utils.ByteArray;

    /**
     * 
     * @author Owner
     */
    public final class PacketUtil 
    {
        public static function newByteArray(src:ByteArray, pos:int, len:int):ByteArray
        {
            var dst:ByteArray = new ByteArray();

            src.position = pos;
            src.readBytes(dst, 0, len);
            src.position = 0;
            dst.position = 0;
            return dst;
        }

        public static function hexDump(byteAry:ByteArray):String
        {
            if (byteAry == null)
            {
                return "<null>";
            }

            var hexChars:String = "0123456789ABCDEF";
            var bytesPerLine:int = 16;
            var bytesLength:int = byteAry.length;
            var firstHexColumn:int =
                  8                   // 8 characters for the address
                + 3;                  // 3 spaces
            var firstCharColumn:int = firstHexColumn
                + bytesPerLine * 3       // - 2 digit for the hexadecimal value and 1 space
                + (bytesPerLine - 1) / 8 // - 1 extra space every 8 characters from the 9th
                + 2;                  // 2 spaces 
            var lineLength:int = firstCharColumn
                + bytesPerLine           // - characters to show the ascii value
                + 2; // Carriage return and line feed (should normally be 2)
            //var expectedLines:int = (bytesLength + bytesPerLine - 1) / bytesPerLine;
            var retStr:String = "";
            var i:int;
            var j:int;
            var line:ByteArray = new ByteArray();
            var hexColumn:int = 0;
            var charColumn:int = 0;
            var byte:int = 0;

			for (i = 0; i < lineLength - 2; i++)
			{
				line[i] = " ".charCodeAt(0);
			}
			//line[lineLength - 2] = "\r".charCodeAt(0);
			//line[lineLength - 1] = "\n".charCodeAt(0);
			//line[lineLength] = 0;

            for (i = 0; i < bytesLength; i += bytesPerLine)
            {
                line[0] = hexChars.charCodeAt((i >> 28) & 0xF);
                line[1] = hexChars.charCodeAt((i >> 24) & 0xF);
                line[2] = hexChars.charCodeAt((i >> 20) & 0xF);
                line[3] = hexChars.charCodeAt((i >> 16) & 0xF);
                line[4] = hexChars.charCodeAt((i >> 12) & 0xF);
                line[5] = hexChars.charCodeAt((i >> 8) & 0xF);
                line[6] = hexChars.charCodeAt((i >> 4) & 0xF);
                line[7] = hexChars.charCodeAt((i >> 0) & 0xF);

                hexColumn = firstHexColumn;
                charColumn = firstCharColumn;

                for (j = 0; j < bytesPerLine; j++)
                {
                    if (j > 0 && (j & 7) == 0)
                    {
                        hexColumn++;
                    }
                    if (i + j >= bytesLength)
                    {
                        line[hexColumn] = " ".charCodeAt(0);
                        line[hexColumn + 1] = " ".charCodeAt(0);
                        line[charColumn] = " ".charCodeAt(0);
                    }
                    else
                    {
                        byte = byteAry[i + j];
                        line[hexColumn] = hexChars.charCodeAt((byte >> 4) & 0xF);
                        line[hexColumn + 1] = hexChars.charCodeAt(byte & 0xF);
                        line[charColumn] = (byte < 32 ? '·' : byte);
                    }
                    hexColumn += 3;
                    charColumn++;
                }
				line.position = 0;
                retStr += line.readUTFBytes(lineLength - 2) + "\r\n";
            }
            return retStr;
        }
   }

}