
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace renter.Models.ViewModel
{
    public class BookingVM
    {
        public Property property { get; set; }
        public IdentityUser user { get; set; }

    }
}
