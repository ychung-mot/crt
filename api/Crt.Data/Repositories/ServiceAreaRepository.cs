using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.ServiceArea;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IServiceAreaRepository
    {
        IEnumerable<ServiceAreaDto> GetAllServiceAreas();
        Task<IEnumerable<ServiceAreaDto>> GetAllServiceAreasAsync();
        Task<ServiceAreaDto> GetServiceAreaByIdAsync(decimal id);
    }

    public class ServiceAreaRepository : CrtRepositoryBase<CrtServiceArea>, IServiceAreaRepository
    {
        public ServiceAreaRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        { }

        public IEnumerable<ServiceAreaDto> GetAllServiceAreas()
        {
            return GetAll<ServiceAreaDto>();
        }

        public async Task<IEnumerable<ServiceAreaDto>> GetAllServiceAreasAsync()
        {
            return await GetAllAsync<ServiceAreaDto>();
        }

        public async Task<ServiceAreaDto> GetServiceAreaByIdAsync(decimal id)
        {
            var entity = await DbSet.AsNoTracking()
                .Where(r => r.EndDate == null || r.EndDate > DateTime.Today)
                .FirstOrDefaultAsync(d => d.ServiceAreaId == id);

            return Mapper.Map<ServiceAreaDto>(entity);
        }
    }
}
