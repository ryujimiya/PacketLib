package livefan.packet
{

    /**
     * 
     * @author Owner
     */
    public final class TcpCtrlFlag 
    {
        public static const CWR:uint = 128;
        public static const ECN:uint = 64;
        public static const URG:uint = 32;
        public static const ACK:uint = 16;
        public static const PSH:uint = 8;
        public static const RST:uint = 4;
        public static const SYN:uint = 2;
        public static const FIN:uint = 1;
    }

}