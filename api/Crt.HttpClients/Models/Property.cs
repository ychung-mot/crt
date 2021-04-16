namespace Crt.HttpClients.Models
{
    public class Property
    {
        public string NE_UNIQUE { get; set; }
        public float NE_LENGTH { get; set; }
        public string NE_DESCR { get; set; }
        public float MEASURE { get; set; }        
        public double POINT_VARIANCE { get; set; }
        //complete & clipped length used by Ratio determination
        public double COMPLETE_LENGTH_KM { get; set; }
        public double? CLIPPED_LENGTH_KM { get; set; }
        //ED_ABBREV and ECONO REGION returned from DataBC calls
        public string ED_ABBREVIATION { get; set; }
        public string ECONOMIC_REGION_NAME { get; set; }
        //CONTRACT_AREA (Service) & DISTRICT number returned from GeoServer
        public int CONTRACT_AREA_NUMBER { get; set; }
        public int DISTRICT_NUMBER { get; set; }
    }
}