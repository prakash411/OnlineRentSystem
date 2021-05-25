using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using renter.Data;
using renter.Models;
using renter.Models.ViewModel;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace renter.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly ApplicationDbContext _db;
        private readonly UserManager<IdentityUser> _userManager;
        public HomeController(  
            ILogger<HomeController> logger,
            ApplicationDbContext db,
            UserManager<IdentityUser> userManager)
        {
            _logger = logger; 
            _db = db;
            _userManager = userManager;
        }

        public IActionResult Index()
        {
            
            IEnumerable<Property> objList = _db.Propertys;
            return View(objList);
        }

        [Authorize]
        public IActionResult Details(int? id)
        {
            Property property = new Property();

            if (id == null)
            {
                //this is for create
                return NotFound();
            }
            else
            {
                property = _db.Propertys.Find(id);
                if (property == null)
                {
                    return NotFound();
                }
                return View(property);
            }
        }

        [Authorize]
        public IActionResult Summary(int? id)
        {
            BookingVM obj = new BookingVM();

            if (id == null)
            {
                //this is for create
                return NotFound();
            }
            else
            {
                var userid = _userManager.GetUserId(HttpContext.User);
                obj.user = _userManager.FindByIdAsync(userid).Result;
                obj.property = _db.Propertys.Find(id);
                if (userid == null || obj.property==null || obj.user == null)
                {
                    return NotFound();
                }
                IEnumerable<Booking> objList = _db.Booking;
                foreach (var i in objList)
                {
                    if(i.CustomerName==obj.user.UserName && i.PropertyId == obj.property.PropertyId)
                    {
                        TempData["mes"] = "You already Book this propert, please check the Booking List";
                        TempData["status"] = "error";
                        return RedirectToAction("MyBooking", "Booking");
                    }
                }
                return View(obj);
            }
        }

        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Summary(BookingVM obj)
        {
            Booking booking = new Booking()
            {
                CustomerName = obj.user.UserName,
                CustomerEmail=obj.user.Email,
                CustomerNumber=obj.user.PhoneNumber,
                OwnerName=obj.property.OwnerName,
                PropertyId=obj.property.PropertyId,
                BookingStatus="Pending"
            };                     

            _db.Booking.Add(booking);
            TempData["mes"] = "Request Send Successfully 👍";
            TempData["status"] = "success";
            _db.SaveChanges();
            return RedirectToAction("Index","Booking");
        }

            [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
