import React from 'react';
import { Link } from 'react-router-dom';
import { FaMapMarkerAlt } from 'react-icons/fa';

export default function ProjectCard({ project }) {
  const fallbackImage = 'https://balaji-api-guru.onrender.com/images/drive/1LKAwd5bWGCbqRgX0ZK2FzCIXkjnFgEkn';
  
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition flex flex-col h-full">
      {/* Image - Full Width Top */}
      <div className="w-full bg-gray-200 relative h-40 sm:h-48 md:h-56 overflow-hidden flex-shrink-0">
        <img 
          src={project.image || fallbackImage} 
          alt={project.title}
          className="w-full h-full object-cover"
          onError={(e) => {e.target.src = fallbackImage}}
        />
        {/* Status Badge - Top Right */}
        <div className="absolute top-2 right-2">
          <span className={`inline-block px-3 py-1 rounded text-white text-xs font-semibold ${
            project.status === 'Ongoing' ? 'bg-blue-600' :
            project.status === 'Completed' ? 'bg-green-600' :
            'bg-amber-600'
          }`}>
            {project.status}
          </span>
        </div>
      </div>

      {/* Content - Below Image */}
      <div className="p-3 sm:p-4 md:p-5 flex flex-col flex-1">
        {/* Title */}
        <h3 className="text-base sm:text-lg font-bold text-gray-900 mb-2 line-clamp-2">{project.title}</h3>
        
        {/* Location */}
        <div className="flex items-start text-gray-700 mb-2 sm:mb-3">
          <FaMapMarkerAlt className="mr-2 text-gray-600 flex-shrink-0 text-xs sm:text-sm mt-0.5" />
          <p className="text-xs sm:text-sm line-clamp-1">{project.location}</p>
        </div>

        {/* Description */}
        <p className="text-gray-600 text-xs mb-3 sm:mb-4 line-clamp-2">{project.description}</p>

        {/* Info Row */}
        <div className="grid grid-cols-3 gap-2 sm:gap-3 mb-3 sm:mb-4 pb-3 sm:pb-4 border-b border-gray-200">
          <div>
            <p className="text-xs text-gray-500 font-semibold">TYPE</p>
            <p className="text-xs sm:text-sm font-bold text-gray-800">{project.type}</p>
          </div>
          <div>
            <p className="text-xs text-gray-500 font-semibold">UNITS</p>
            <p className="text-xs sm:text-sm font-bold text-gray-800">{project.totalUnits}</p>
          </div>
          <div>
            <p className="text-xs text-gray-500 font-semibold">AVAILABLE</p>
            <p className="text-xs sm:text-sm font-bold text-gray-800">{project.availableUnits}</p>
          </div>
        </div>

        {/* Price */}
        <div className="mb-3 sm:mb-4 flex-1">
          <p className="text-xs text-gray-500 font-semibold mb-1">FROM</p>
          <p className="text-xl sm:text-2xl font-bold text-amber-600">{project.priceRange}</p>
        </div>

        {/* CTA Button */}
        <Link 
          to={`/project/${project._id}`}
          className="w-full block text-center bg-amber-600 hover:bg-amber-700 text-white font-bold py-2 sm:py-3 px-4 rounded transition text-xs sm:text-sm mt-auto"
        >
          VIEW DETAILS
        </Link>
      </div>
    </div>
  );
}
