using Crt.Data.Repositories;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Project;
using Crt.Model.Utils;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IProjectService
    {
        Task<PagedDto<ProjectSearchDto>> GetProjectsAsync(string? regions,
            string searchText, bool? isInProgress, string projectManagerIds,
            int pageSize, int pageNumber, string orderBy, string direction);

        Task<ProjectDto> GetProjectAsync(decimal projectId);
    }

    public class ProjectService : IProjectService
    {
        private CrtCurrentUser _currentUser;
        private IProjectRepository _projectRepo;

        public ProjectService(CrtCurrentUser currentUser, IProjectRepository projectRepo)
        {
            _currentUser = currentUser;
            _projectRepo = projectRepo;
        }

        public async Task<PagedDto<ProjectSearchDto>> GetProjectsAsync(string? regions,
            string searchText, bool? isInProgress, string projectManagerIds,
            int pageSize, int pageNumber, string orderBy, string direction)
        {
            //limitted to user regions
            var filteredRegions = regions.ToDecimalArray().Where(x => _currentUser.UserInfo.RegionIds.Contains(x)).ToArray();

            return await _projectRepo.GetProjectsAsync(filteredRegions, searchText, isInProgress, projectManagerIds.ToDecimalArray(),
                pageSize, pageNumber, orderBy, direction);
        }

        public async Task<ProjectDto> GetProjectAsync(decimal projectId)
        {
            return await _projectRepo.GetProjectAsync(projectId);
        }
    }
}
