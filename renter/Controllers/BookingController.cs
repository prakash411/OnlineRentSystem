using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using renter.Data;
using renter.Models;
using renter.Models.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace renter.Controllers
{
    [Authorize]
    public class BookingController : Controller
    {
        private readonly ApplicationDbContext _db;

        public BookingController(ApplicationDbContext db)
        {
            _db = db;
        }

        public IActionResult Index()
        {            
            return View();
        }

        public IActionResult MyBooking()
        {
            var U_id = (ClaimsIdentity)User.Identity;
            IEnumerable<Booking> objList = _db.Booking.Where(x => x.CustomerName == U_id.Name);
            return View(objList);
        }
        public IActionResult Inquiry()
        {
            var U_id = (ClaimsIdentity)User.Identity;
            IEnumerable<Booking> objList = _db.Booking.Where(x => x.OwnerName == U_id.Name);
            return View(objList);
        }
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

        public IActionResult Details2(int? id)
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
        public IActionResult Accept(int? id)
        {
            Booking obj = _db.Booking.Find(id);
            obj.BookingStatus = "Accepted";
            _db.Booking.Update(obj);
            _db.SaveChanges();
            return RedirectToAction("Inquiry");
        }
        public IActionResult Denied(int? id)
        {
            Booking obj = _db.Booking.Find(id);
            obj.BookingStatus = "Denied";
            _db.Booking.Update(obj);
            _db.SaveChanges();
            return RedirectToAction("Inquiry");
        }
        public IActionResult Cancel(int? id)
        {
            Booking obj = _db.Booking.Find(id);
            _db.Booking.Remove(obj);
            TempData["mes"] = "Deleted Successfully 👍";
            TempData["status"] = "success";
            _db.SaveChanges();
            return RedirectToAction("MyBooking");
        }
    }
}
