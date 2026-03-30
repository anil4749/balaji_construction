import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

export default function HeroSection() {
  const { t } = useTranslation();
  const navigate = useNavigate();

  return (
    <section className="relative h-auto sm:h-screen sm:min-h-screen bg-cover bg-center bg-fixed" 
      style={{backgroundImage: 'url(https://picsum.photos/1200/600?random=hero)'}}>
      
      <div className="absolute inset-0 bg-black opacity-40"></div>
      
      <div className="relative max-w-7xl mx-auto h-auto sm:h-full flex items-center justify-center px-3 sm:px-4 py-12 sm:py-0">
        <div className="text-center text-white">
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
