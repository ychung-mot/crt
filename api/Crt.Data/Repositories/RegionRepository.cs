using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model.Dtos.Region;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IRegionRepository
    {
        IEnumerable<RegionDto> GetAllRegions();
        Task<IEnumerable<RegionDto>> GetAllRegionsAsync();
        Task<RegionDto> GetRegionByRegionNumber(decimal regionNumber);
        Task<RegionDto> GetRegionByRegionId(decimal id);
    }

    public class RegionRepository : CrtRepositoryBase<CrtRegion>, IRegionRepository
    {
        public RegionRepository(AppDbContext dbContext, IMapper mapper)
            : base(dbContext, mapper)
        {}

        public IEnumerable<RegionDto> GetAllRegions()
        {
            return GetAll<RegionDto>();
        }

        public async Task<IEnumerable<RegionDto>> GetAllRegionsAsync()
        {
            return await GetAllAsync<RegionDto>();
        }

        public async Task<RegionDto> GetRegionByRegionId(decimal id)
        {
            var entity = await DbSet.AsNoTracking()
                .FirstAsync(r => r.RegionId == id);

            return Mapper.Map<RegionDto>(entity);
        }

        public async Task<RegionDto> GetRegionByRegionNumber(decimal number)
        {
            var entity = await DbSet.AsNoTracking()
                .FirstAsync(r => r.RegionNumber == number);

            return Mapper.Map<RegionDto>(entity);
        }
    }
}
