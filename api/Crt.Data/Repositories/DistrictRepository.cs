using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.District;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IDistrictRepository
    {
        IEnumerable<DistrictDto> GetAllDistricts();
        Task<IEnumerable<DistrictDto>> GetAllDistrictsAsync();
        Task<DistrictDto> GetDistrictByDistrictIdAsync(decimal id);
        Task<DistrictDto> GetDistrictByDistrictNumberAsync(decimal number);
    }

    public class DistrictRepository : CrtRepositoryBase<CrtDistrict>, IDistrictRepository
    {
        public DistrictRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        { }

        public IEnumerable<DistrictDto> GetAllDistricts()
        {
            return GetAll<DistrictDto>();
        }

        public async Task<IEnumerable<DistrictDto>> GetAllDistrictsAsync()
        {
            return await GetAllAsync<DistrictDto>();
        }

        public async Task<DistrictDto> GetDistrictByDistrictIdAsync(decimal id)
        {
            var entity = await DbSet.AsNoTracking()
                .Where(r => r.EndDate == null || r.EndDate > DateTime.Today)
                .FirstOrDefaultAsync(d => d.DistrictId == id);

            return Mapper.Map<DistrictDto>(entity);
        }
         
        public async Task<DistrictDto> GetDistrictByDistrictNumberAsync(decimal number)
        {
            var entity = await DbSet.AsNoTracking()
                .Where(r => r.EndDate == null || r.EndDate > DateTime.Today)
                .FirstOrDefaultAsync(d => d.DistrictNumber == number);

            return Mapper.Map<DistrictDto>(entity);
        }
    }
}
