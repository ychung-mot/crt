using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.QtyAccmp;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IQtyAccmpRepository
    {
        Task<QtyAccmpDto> GetQtyAccmpByIdAsync(decimal qtyAccmpId);
        Task<CrtQtyAccmp> CreateQtyAccmpAsync(QtyAccmpCreateDto qtyAccmp);
        Task UpdateQtyAccmpAsync(QtyAccmpUpdateDto qtyAccmp);
        Task DeleteQtyAccmpAsync(decimal qtyAccmpId);
        Task<CrtQtyAccmp> CloneQtyAccmpAsync(decimal qtyAccmpId);
    }

    public class QtyAccmpRepository : CrtRepositoryBase<CrtQtyAccmp>, IQtyAccmpRepository
    {
        public QtyAccmpRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<QtyAccmpDto> GetQtyAccmpByIdAsync(decimal qtyAccmpId)
        {
            var qtyAccmp = await DbSet.AsNoTracking()
                .Include(x => x.Project)
                .Include(x => x.FiscalYearLkup)
                .Include(x => x.QtyAccmpLkup)
                .FirstOrDefaultAsync(x => x.QtyAccmpId == qtyAccmpId);

            return Mapper.Map<QtyAccmpDto>(qtyAccmp);
        }

        public async Task<CrtQtyAccmp> CreateQtyAccmpAsync(QtyAccmpCreateDto qtyAccmp)
        {
            var crtQtyAccmp = new CrtQtyAccmp();

            Mapper.Map(qtyAccmp, crtQtyAccmp);

            await DbSet.AddAsync(crtQtyAccmp);

            return crtQtyAccmp;
        }

        public async Task UpdateQtyAccmpAsync(QtyAccmpUpdateDto qtyAccmp)
        {
            var crtQtyAccmp = await DbSet
                                .FirstAsync(x => x.ProjectId == qtyAccmp.ProjectId && x.QtyAccmpId == qtyAccmp.QtyAccmpId);

            crtQtyAccmp.EndDate = qtyAccmp.EndDate?.Date;

            Mapper.Map(qtyAccmp, crtQtyAccmp);
        }

        public async Task DeleteQtyAccmpAsync(decimal qtyAccmpId)
        {
            var crtQtyAccmp = await DbSet
                                .FirstAsync(x => x.QtyAccmpId == qtyAccmpId);

            DbSet.Remove(crtQtyAccmp);
        }

        public async Task<CrtQtyAccmp> CloneQtyAccmpAsync(decimal qtyAccmpId)
        {
            var crtQtyAccmp = await DbSet
                .FirstAsync(x => x.QtyAccmpId == qtyAccmpId);

            var qtyAccmpCreateDto = new QtyAccmpCreateDto();

            Mapper.Map(crtQtyAccmp, qtyAccmpCreateDto);

            return await CreateQtyAccmpAsync(qtyAccmpCreateDto);
        }
    }
}
