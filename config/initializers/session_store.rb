Rails.application.config.session_store :cookie_store,
                                       key: '_your_app_session',
                                       same_site: :none,
                                       secure: true,
                                       expire_after: 14.days

Rails.application.config.action_dispatch.cookies_same_site_protection = :none
