import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { getDriveImageUrl, DRIVE_IMAGES } from '../utils/driveImages';

export default function HeroSection() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const heroImageUrl = DRIVE_IMAGES?.hero ? getDriveImageUrl(DRIVE_IMAGES.hero) : '';

  return (
    <section className="relative w-full min-h-screen sm:min-h-screen overflow-hidden"> 
      {/* Responsive Hero Image - No Cropping */}
      <img 
        src={heroImageUrl || '/placeholder-hero.jpg'}
        alt="Hero Background"
        className="absolute inset-0 w-full h-full object-contain object-center"
        loading="lazy"
        onError={(e) => e.target.style.display = 'none'}
      />
      
      {/* Dark overlay */}
      <div className="absolute inset-0 bg-black opacity-40 z-10"></div>
      
      {/* Content - Positioned on top of image and overlay */}
      <div className="relative z-20 min-h-screen w-full max-w-7xl mx-auto flex items-center justify-center px-3 sm:px-4 py-12 sm:py-0">
        <div className="text-center text-white w-full">
          <h2 className="text-2xl sm:text-4xl md:text-5xl lg:text-6xl font-bold mb-2 sm:mb-4">{t('hero.title')}</h2>
          <p className="text-sm sm:text-lg md:text-xl lg:text-2xl mb-4 sm:mb-8">{t('hero.subtitle')}</p>
          <p className="text-xs sm:text-base md:text-lg mb-4 sm:mb-8 max-w-2xl mx-auto">
            {t('hero.description')}
          </p>
          <div className="flex flex-col sm:flex-row gap-2 sm:gap-4 justify-center">
            <button 
              onClick={() => navigate('/projects')}
              className="bg-amber-600 hover:bg-amber-700 text-white font-bold py-2 sm:py-3 px-4 sm:px-8 rounded-lg transition text-xs sm:text-base">
              {t('hero.cta')}
            </button>
            <button 
              onClick={() => navigate('/contact')}
              className="bg-white hover:bg-gray-200 text-amber-700 font-bold py-2 sm:py-3 px-4 sm:px-8 rounded-lg transition text-xs sm:text-base">
              {t('inquiry.submitInquiry')}
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
