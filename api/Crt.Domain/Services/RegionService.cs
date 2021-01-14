using Crt.Data.Repositories;
using Crt.Model.Dtos.Region;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IRegionService
    {
        IEnumerable<RegionDto> GetAllRegions();
        Task<IEnumerable<RegionDto>> GetAllRegionsAsync();
        Task<RegionDto> GetRegionByRegionId(decimal id);
    }

    public class RegionService : IRegionService
    {
        private IRegionRepository _regionRepo;

        public RegionService(IRegionRepository regionRepo)
        {
            _regionRepo = regionRepo;
        }

        public IEnumerable<RegionDto> GetAllRegions()
        {
            return _regionRepo.GetAllRegions();
        }

        public async Task<IEnumerable<RegionDto>> GetAllRegionsAsync()
        {
            return await _regionRepo.GetAllRegionsAsync();
        }

        public async Task<RegionDto> GetRegionByRegionId(decimal id)
        {
            return await _regionRepo.GetRegionByRegionId(id);
        }
    }
}
