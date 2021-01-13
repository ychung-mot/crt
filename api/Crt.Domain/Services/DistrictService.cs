using Crt.Data.Repositories;
using Crt.Model.Dtos.District;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IDistrictService
    {
        IEnumerable<DistrictDto> GetAllDistricts();
        Task<IEnumerable<DistrictDto>> GetAllDistrictsAsync();
        Task<DistrictDto> GetDistrictByDistrictNumber(decimal districtNumber);
    }

    public class DistrictService : IDistrictService
    {
        private IDistrictRepository _districtRepo;

        public DistrictService(IDistrictRepository districtRepo)
        {
            _districtRepo = districtRepo;
        }

        public IEnumerable<DistrictDto> GetAllDistricts()
        {
            return _districtRepo.GetAllDistricts();
        }

        public async Task<IEnumerable<DistrictDto>> GetAllDistrictsAsync()
        {
            return await _districtRepo.GetAllDistrictsAsync();
        }

        public async Task<DistrictDto> GetDistrictByDistrictNumber(decimal districtNumber)
        {
            return await _districtRepo.GetDistrictByDistrictNumber(districtNumber);
        }
    }
}
