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
        Task<DistrictDto> GetDistrictByDistrictId(decimal id);
        Task<DistrictDto> GetDistrictByDistrictNumber(decimal number);
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

        public async Task<DistrictDto> GetDistrictByDistrictId(decimal id)
        {
            var entity = await DbSet.AsNoTracking()
                .FirstAsync(d => d.DistrictId == id);

            return Mapper.Map<DistrictDto>(entity);
        }

        public async Task<DistrictDto> GetDistrictByDistrictNumber(decimal number)
        {
            var entity = await DbSet.AsNoTracking()
                .FirstAsync(d => d.DistrictNumber == number);

            return Mapper.Map<DistrictDto>(entity);
        }
    }
}
