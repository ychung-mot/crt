using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.Ratio;
using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;

namespace Crt.Data.Repositories
{
    public interface IRatioRepository
    {
        Task<RatioDto> GetRatioByIdAsync(decimal ratioId);
        Task<IEnumerable<RatioDto>> GetRatiosByRatioTypeAsync(decimal ratioTypeId);
        Task<CrtRatio> CreateRatioAsync(RatioCreateDto ratio);
        Task UpdateRatioAsync(RatioUpdateDto ratio);
        Task DeleteRatioAsync(decimal ratioId);
    }

    public class RatioRepository : CrtRepositoryBase<CrtRatio>, IRatioRepository
    {
        public RatioRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<CrtRatio> CreateRatioAsync(RatioCreateDto ratio)
        {
            var crtRatio = new CrtRatio();

            Mapper.Map(ratio, crtRatio);

            await DbSet.AddAsync(crtRatio);

            return crtRatio;
        }

        public async Task DeleteRatioAsync(decimal ratioId)
        {
            var ratio = await DbSet
                .FirstAsync(x => x.RatioId == ratioId);

            DbSet.Remove(ratio);
        }

        public async Task<RatioDto> GetRatioByIdAsync(decimal ratioId)
        {
            var ratio = await DbSet.AsNoTracking()
                .Include(x => x.Project)
                .Include(x => x.RatioObjectLkup)
                .Include(x => x.RatioObjectTypeLkup)
                .FirstOrDefaultAsync(x => x.RatioId == ratioId);

            return Mapper.Map<RatioDto>(ratio);
        }

        public async Task<IEnumerable<RatioDto>> GetRatiosByRatioTypeAsync(decimal ratioTypeId)
        {
            return await GetAllNoTrackAsync<RatioDto>(x => x.RatioObjectTypeLkupId == ratioTypeId);
        }

        public async Task UpdateRatioAsync(RatioUpdateDto ratio)
        {
            var crtRatio = await DbSet
                .FirstAsync(x => x.ProjectId == ratio.ProjectId && x.RatioId == ratio.RatioId);

            ratio.EndDate = ratio.EndDate?.Date;

            Mapper.Map(ratio, crtRatio);
        }
    }
}
