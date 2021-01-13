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

        public async Task<RegionDto> GetRegionByRegionNumber(decimal regionNumber)
        {
            var entity = await DbSet.AsNoTracking()
                .FirstAsync(r => r.RegionNumber == regionNumber);

            return Mapper.Map<RegionDto>(entity);
        }
    }
}
