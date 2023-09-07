Rails.application.config.session_store :cookie_store,
                                       key: '_your_app_session',
                                       secure: Rails.env.production?,
                                       same_site: :none,
                                       expire_after: 14.days,
                                       domain: :all
