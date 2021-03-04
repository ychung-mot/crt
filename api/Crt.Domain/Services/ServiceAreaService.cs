using Crt.Data.Repositories;
using Crt.Model.Dtos.ServiceArea;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
  
    public interface IServiceAreaService
    {
        IEnumerable<ServiceAreaDto> GetAllServiceAreas();
        Task<IEnumerable<ServiceAreaDto>> GetAllServiceAreasAsync();
        Task<ServiceAreaDto> GetServiceAreaById(decimal id);
    }

    public class ServiceAreaService : IServiceAreaService
    {
        private IServiceAreaRepository _serviceAreaRepo;

        public ServiceAreaService(IServiceAreaRepository serviceAreaRepo)
        {
            _serviceAreaRepo = serviceAreaRepo;
        }

        public IEnumerable<ServiceAreaDto> GetAllServiceAreas()
        {
            return _serviceAreaRepo.GetAllServiceAreas();
        }

        public async Task<IEnumerable<ServiceAreaDto>> GetAllServiceAreasAsync()
        {
            return await _serviceAreaRepo.GetAllServiceAreasAsync();
        }

        public async Task<ServiceAreaDto> GetServiceAreaById(decimal id)
        {
            return await _serviceAreaRepo.GetServiceAreaByIdAsync(id);
        }
    }
}

