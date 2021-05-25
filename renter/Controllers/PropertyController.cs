using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using renter.Data;
using renter.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace renter.Controllers
{
    [Authorize]
    public class PropertyController : Controller
    {
        private readonly ApplicationDbContext _db;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public PropertyController(ApplicationDbContext db, IWebHostEnvironment webHostEnvironment)
        {
            _db = db;
            _webHostEnvironment = webHostEnvironment;
        }
        public IActionResult Index()
        {
            var U_id = (ClaimsIdentity)User.Identity;
            IEnumerable<Property> objList = _db.Propertys.Where(x=>x.OwnerName == U_id.Name);
            return View(objList);
        }

        //GET - Upsert
        public IActionResult Upsert(int? id)
        {
            Property property = new Property();

            if (id == null)
            {
                //this is for create
                return View(property);
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


        //POST - Upsert
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Upsert(Property property)
        {
            var U_id = (ClaimsIdentity)User.Identity;
            property.OwnerName = U_id.Name;
            if (ModelState.IsValid)
            {
                var files = HttpContext.Request.Form.Files;
                string upload = _webHostEnvironment.WebRootPath + @"\Images\";
                string wholeFiles = "";

                if (property.PropertyId == 0)
                {
                    //create
                    if (files.Count > 0)
                    {
                        foreach (var file in files)
                        {
                            string fileName = Guid.NewGuid().ToString() + "_" + file.FileName;
                            using (var fileStream = new FileStream(Path.Combine(upload, fileName), FileMode.Create))
                            {
                                file.CopyTo(fileStream);
                            }
                            wholeFiles += fileName + "$";
                        }
                        property.Image = wholeFiles;
                    }
                    else
                    {
                        property.Image = "House.png$";
                    }
                    
                    _db.Propertys.Add(property);
                    TempData["mes"] = "Property Posted Successfully 👍";
                    TempData["status"] = "success";
                }
                else
                {
                    //updating
                    var objFromDb = _db.Propertys.AsNoTracking().FirstOrDefault(u => u.PropertyId == property.PropertyId);

                    if (files.Count > 0)
                    {
                        var x = objFromDb.Image;
                        string[] aList = x.Split("$");
                        foreach (var i in aList)
                        {
                            var oldFile = Path.Combine(upload, i);

                            if (System.IO.File.Exists(oldFile))
                            {
                                System.IO.File.Delete(oldFile);
                            }

                        }
                        foreach (var file in files)
                        {
                            string fileName = Guid.NewGuid().ToString() + "_" + file.FileName;
                            using (var fileStream = new FileStream(Path.Combine(upload, fileName), FileMode.Create))
                            {
                                file.CopyTo(fileStream);
                            }
                            wholeFiles += fileName + "$";

                        }
                        property.Image = wholeFiles;
                    }
                    else
                    {
                        property.Image = objFromDb.Image;
                    }
                    _db.Propertys.Update(property);
                    TempData["mes"] = "Update Successfully 👍";
                    TempData["status"] = "success";
                }
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(property);

        }

        public IActionResult Delete(int? id)
        {
            if (id == null || id == 0)
            {
                return NotFound();
            }
            var obj = _db.Propertys.Find(id);
            if (obj == null)
            {
                return NotFound();
            }

            string upload = _webHostEnvironment.WebRootPath + @"\Images\";
            var x = obj.Image;
            string[] aList = x.Split("$");
            foreach (var i in aList)
            {
                var oldFile = Path.Combine(upload, i);

                if (System.IO.File.Exists(oldFile))
                {
                    System.IO.File.Delete(oldFile);
                }

            }


            _db.Propertys.Remove(obj);
            TempData["mes"] = "Deleted Successfully 👍";
            TempData["status"] = "success";
            _db.SaveChanges();
            return RedirectToAction("Index");
        }
    }
}
