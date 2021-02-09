using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.Project;
using Crt.Model.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IFinTargetRepository
    {
        Task<FinTargetDto> GetFinTargetByIdAsync(decimal finTargetId);
        Task<CrtFinTarget> CreateFinTargetAsync(FinTargetCreateDto finTarget);
        Task UpdateFinTargetAsync(FinTargetUpdateDto finTarget);
        Task DeleteFinTargetAsync(decimal finTargetId);
        Task<bool> ElementExists(decimal elementId);
    }

    public class FinTargetRepository : CrtRepositoryBase<CrtFinTarget>, IFinTargetRepository
    {
        public FinTargetRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<FinTargetDto> GetFinTargetByIdAsync(decimal finTargetId)
        {
            var finTarget = await DbSet.AsNoTracking()
                .Include(x => x.Project)
                .Include(x => x.Element)
                .Include(x => x.FiscalYearLkup)
                .Include(x => x.ForecastTypeLkup)
                .Include(x => x.PhaseLkup)
                .FirstOrDefaultAsync(x => x.FinTargetId == finTargetId);

            return Mapper.Map<FinTargetDto>(finTarget);
        }

        public async Task<CrtFinTarget> CreateFinTargetAsync(FinTargetCreateDto finTarget)
        {
            var crtFinTarget = new CrtFinTarget();

            Mapper.Map(finTarget, crtFinTarget);

            await DbSet.AddAsync(crtFinTarget);

            return crtFinTarget;
        }

        public async Task UpdateFinTargetAsync(FinTargetUpdateDto finTarget)
        {
            var crtFinTarget = await DbSet
                                .FirstAsync(x => x.FinTargetId == finTarget.FinTargetId);

            crtFinTarget.EndDate = finTarget.EndDate?.Date;

            Mapper.Map(finTarget, crtFinTarget);
        }

        public async Task DeleteFinTargetAsync(decimal finTargetId)
        {
            var crtFinTarget = await DbSet
                                .FirstAsync(x => x.FinTargetId == finTargetId);

            DbSet.Remove(crtFinTarget);
        }

        public async Task<bool> ElementExists(decimal elementId)
        {
            return await DbContext.CrtElements.AnyAsync(x => x.ElementId == elementId && (x.EndDate == null || x.EndDate > DateTime.Today));
        }
    }
}
