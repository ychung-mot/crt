using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model.Dtos.District;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IDistrictRepository
    {
        IEnumerable<DistrictDto> GetAllDistricts();
        Task<IEnumerable<DistrictDto>> GetAllDistrictsAsync();
        Task<DistrictDto> GetDistrictByDistrictNumber(decimal districtNumber);
    }

    public class DistrictRepository : CrtRepositoryBase<CrtDistrict>, IDistrictRepository
    {
        public DistrictRepository(AppDbContext dbContext, IMapper mapper)
            : base(dbContext, mapper)
        { }

        public IEnumerable<DistrictDto> GetAllDistricts()
        {
            return GetAll<DistrictDto>();
        }

        public async Task<IEnumerable<DistrictDto>> GetAllDistrictsAsync()
        {
            return await GetAllAsync<DistrictDto>();
        }

        public async Task<DistrictDto> GetDistrictByDistrictNumber(decimal districtNumber)
        {
            var entity = await DbSet.AsNoTracking()
                .FirstAsync(d => d.DistrictNumber == districtNumber);

            return Mapper.Map<DistrictDto>(entity);
        }
    }
}
