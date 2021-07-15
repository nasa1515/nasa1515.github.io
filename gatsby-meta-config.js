module.exports = {
  title: `NASA1515의 Tech Blog`,
  description: `NASA1515의 기술 블로그`,
  language: `ko`, // `ko`, `en` => currently support versions for Korean and English
  siteUrl: `https://nasa1515.github.io/`,
  ogImage: `/og-image.png`, // Path to your image you placed in the 'static' folder
  comments: {
    utterances: {
      repo: `nasa1515/nasa1515.github.io`,
    },
  },
  ga: 'UA-192755809-1', // Google Analytics Tracking ID
  author: {
    name: `NASA1515`,
    bio: {
      role: `데이터 엔지니어`,
      description: ['계산을 좋아하는', '협업을 좋아하는'],
      isVideo: true,
    },
    social: {
      github: `https://github.com/nasa1515`,
      linkedIn: `https://www.linkedin.com/in/wonseok-lee-60b9011a3/`,
      email: `h43254@gmail.com`,
    },
  },

  // metadata for About Page
  about: {
    timestamps: [
      // =====       [Timestamp Sample and Structure]      =====
      // ===== 🚫 Don't erase this sample (여기 지우지 마세요!) =====
      {
        date: '',
        activity: '',
        links: {
          github: '',
          post: '',
          googlePlay: '',
          appStore: '',
        },
      },
      // ========================================================
      // ========================================================
      {
        date: '2020.12 ~ ',
        activity: 'Cloocus Data Analytics🚀',
      },
    ],

    projects: [
      // =====        [Project Sample and Structure]        =====
      // ===== 🚫 Don't erase this sample (여기 지우지 마세요!) =====
      {
        title: '',
        description: '',
        techStack: ['', ''],
        thumbnailUrl: '',
        links: {
          post: '',
          github: '',
          googlePlay: '',
          appStore: '',
        },
      },
      // ========================================================
      // ========================================================
    ],
  },
};
