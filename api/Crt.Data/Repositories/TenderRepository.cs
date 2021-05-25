using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.Tender;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface ITenderRepository
    {
        Task<TenderDto> GetTenderByIdAsync(decimal tenderId);
        Task<CrtTender> CreateTenderAsync(TenderCreateDto tender);
        Task UpdateTenderAsync(TenderUpdateDto tender);
        Task DeleteTenderAsync(decimal tenderId);
        Task<CrtTender> CloneTenderAsync(decimal tenderId);
        Task<bool> TenderNumberAlreadyExists(decimal projectId, decimal tenderId, string tenderNumber);
    }

    public class TenderRepository : CrtRepositoryBase<CrtTender>, ITenderRepository
    {
        public TenderRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<TenderDto> GetTenderByIdAsync(decimal tenderId)
        {
            var tender = await DbSet.AsNoTracking()
                .Include(x => x.Project)
                .Include(x => x.WinningCntrctrLkup)
                .FirstOrDefaultAsync(x => x.TenderId == tenderId);

            return Mapper.Map<TenderDto>(tender);
        }

        public async Task<CrtTender> CreateTenderAsync(TenderCreateDto tender)
        {
            var crtTender = new CrtTender();

            Mapper.Map(tender, crtTender);

            await DbSet.AddAsync(crtTender);

            return crtTender;
        }

        public async Task UpdateTenderAsync(TenderUpdateDto tender)
        {
            var crtTender = await DbSet
                                .FirstAsync(x => x.ProjectId == tender.ProjectId && x.TenderId == tender.TenderId);

            crtTender.EndDate = tender.EndDate?.Date;

            Mapper.Map(tender, crtTender);
        }

        public async Task DeleteTenderAsync(decimal tenderId)
        {
            var tenderEntity = await DbSet
                                .FirstAsync(x => x.TenderId == tenderId);

            DbSet.Remove(tenderEntity);
        }

        public async Task<CrtTender> CloneTenderAsync(decimal tenderId)
        {
            var source = await DbSet
                .FirstAsync(x => x.TenderId == tenderId);

            var target = new TenderCreateDto();

            Mapper.Map(source, target);

            return await CreateTenderAsync(target);
        }

        public async Task<bool> TenderNumberAlreadyExists(decimal projectId, decimal tenderId, string tenderNumber)
        {
            var tenders = await DbSet.AsNoTracking()
                .Where(x => x.TenderNumber == tenderNumber && x.ProjectId== projectId)
                .Select(x => new { x.TenderId })
                .ToListAsync();

            return tenders.Any(x => x.TenderId != tenderId);
        }
    }
}
