
``TODO``: Import or reference design.rst somehow.

``TODO``: Table of contents

Introduction
============

This page is intended as a manual for administrator users in need of setting up SSO and provisionning users using SCIM on their installation of Wire.

Historically, wire has allowed team admins and owners to manage their users in the team settings app.  This does not scale...

Solution: SCIM! `(System for Cross-domain Identity Management) <https://en.wikipedia.org/wiki/System_for_Cross-domain_Identity_Management>`_ (what's this?)

Historically, wire user auth is via phone or password.  This has security implications: ...; and does not scale either: ...

Solution: SAML! `(Security Assertion Markup Language) <https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language>`_ (future work: Oauth)

Definitions
===========

These concepts need to be understood to use the present manual:

.. note::
    System for Cross-domain Identity Management (SCIM) is a standard for automating the exchange of user identity information between identity domains, or IT systems.
    One example might be that as a company onboards new employees and separates from existing employees, they are added and removed from the company's electronic employee directory. SCIM could be used to automatically add/delete (or, provision/de-provision) accounts for those users in external systems such as G Suite, Office 365, or Salesforce.com. Then, a new user account would exist in the external systems for each new employee, and the user accounts for former employees might no longer exist in those systems.   
    -- Wikipedia

.. note::
    Security Assertion Markup Language (SAML, pronounced SAM-el, /ˈsæməl/) is an open standard for exchanging authentication and authorization data between parties, in particular, between an identity provider and a service provider. SAML is an XML-based markup language for security assertions (statements that service providers use to make access-control decisions). SAML is also:
    * A set of XML-based protocol messages
    * A set of protocol message bindings
    * A set of profiles (utilizing all of the above)
    An important use case that SAML addresses is web-browser `single sign-on (SSO) <https://en.wikipedia.org/wiki/Single_sign-on>`_ . Single sign-on is relatively easy to accomplish within a security domain (using cookies, for example) but extending SSO across security domains is more difficult and resulted in the proliferation of non-interoperable proprietary technologies. The SAML Web Browser `SSO <https://en.wikipedia.org/wiki/Single_sign-on>`_ profile was specified and standardized to promote interoperability.
    -- Wikipedia

Wire comes with a backend module that provides saml single sign on and scim user provisioning for wire. 

You're looking at the administrator's manual.

.. note::
    Note that it is recommended to use both SSO and SCIM (as opposed to just SSO alone). 
    The reason is if you only use SSO, but do not configure/implement SCIM, you will experience reduced functionality.
    In particular, without SCIM all Wire users will be named according their e-mail address and won’t have any rich profiles.

SSO From the user perspective 
=============================

SSO allows users to register and log into Wire with their company credentials that they use on other software in their workplace. 
No need to remember another password.

When a team is set up on Wire, the administrators can provide users a login code or link that they can use to go straight to their company’s login page.

Here is what this looks from a user's perspective:

* Download Wire.
* Select and copy the code that your company gave you / the administrator generated
* Open Wire.
  * Wire may detect the code on your clipboard and open a pop-up window with a text field. Wire will automatically put the code into the text field.
  * If so, click Log in and go to step 8.
* If no pop-up: click Login on the first screen.
* Click Enterprise Login.
* A pop-up will appear. In the text field, paste or type the code your company gave you.
* Click Log in.
* Wire will load your company’s login page: Log in with your company credentials.


SAML/SSO 
========

Terminology and concepts
------------------------

* ``TODO``: IdP (https://en.wikipedia.org/wiki/Identity_provider)
* ``TODO``: Authentication request
* ``TODO``: Authentication response
* ``TODO``: How does the auth flow work (see ./design.rst)
* ``TODO``: [Everything we discuss in https://docs.wire.com/how-to/single-sign-on/trouble-shooting.html, https://docs.wire.com/how-to/single-sign-on/index.html]
* ``TODO``: [Everything that comes to mind while writing this manual]

IdP management (in team settings or via curl)
---------------------------------------------

* ``TODO``: CRUD: Create, Read, Update, Delete in team-settings (some of it is not implemented, also document the curl way for everything?)
* ``TODO``: Deletion is tricky, but solved: the rest api end-point fails if the idp to be deleted is still authenticating active users in the team; but if you move all those users to other IdPs, you can delete it.  
* ``TODO``: There is also a `force` query parameter in the delete end-point that removes all dangling users instead of failing.  
* ``TODO``: What's to be decided is how to add that to team settings. 
* ``TODO``: Currently we need to fall back to the rest api for all this.


Authentication
--------------

* ``TODO``: This could be kind of the user's manual.
* ``TODO``: Or a summary of the user's manual plus a link, if we have it elsewhere. 
* ``TODO``: (``TODO``: talk to srikant and maybe astrid about the new documentation that's to replace support.wire.com, i heard rumors about that).

Setting up SSO externally
-------------------------

``TODO``: Integrate https://support.wire.com/hc/en-us/articles/360001285718-Set-up-SSO-externally

Setting up SSO internally
-------------------------

``TODO``: Integrate https://support.wire.com/hc/en-us/articles/360001285638-Set-up-SSO-internally


SCIM user provisioning
======================

Terminology and concepts
------------------------

``TODO``: - SCIM peer (equivalent to IdP)

SCIM peer management (in team settings or via curl)
---------------------------------------------------

SCIM security and authentication
................................

* ``TODO``: We're using a very basic variant of oauth that just contains a header with a bearer token in all SCIM requests. 
* ``TODO``: The token is created in team settings and added to your scim peer somehow (see howtos or below (wherever we end up putting it) for Azure, curl).

Generating a SCIM token 
.......................

These are the steps to generate a new SCIM token, which you will need to provide to your identity provider (IdP), along with the target API URL, to enable SCIM provisionning.

* Step 1: Go to https://teams.wire.com/settings ( Here replace "wire.com" with your own domain if you have an on-premise installation of Wire ).

.. image:: token-step-1.png
   :align: center

* Step 2: In the left menu, go to «Customization»

.. image:: token-step-2.png
   :align: center

* Step 3: Go to «Automated User Management (SCIM)»

.. image:: token-step-3.png
   :align: center

* Step 4: Click the «down» arrow to expand

.. image:: token-step-4.png
   :align: center

* Step 5: Click «Generate token», if your password is requested, enter it.

.. image:: token-step-5.png
   :align: center

* Step 6: A token is generated, you can copy it

.. image:: token-step-6.png
   :align: center

Tokens are now listed in this SCIM area, you can generate up to 8.

``TODO``: Add arrows/red lines to the images for even more precise instructions.

CRUD in team settings
.....................

``TODO``: Did we implement this fully? I think we may have:

* ``TODO``: We don't need the U in CRUD since we can just delete-and-recreate; and
* ``TODO``: We have just enough R for it to be secure (never expose the token after it's been handed over to the admin).

Using SCIM with azure
---------------------

``TODO``: We have a howto for SAML i think we'll need another one for SCIM.

Using SCIM via curl
-------------------

``TODO``: See `wireapp/wire-server/docs/reference/provisioning/` on github.

SCIM + SSO 
==========

``TODO``: Using SAML SSO without SCIM is deprecated:

* ``TODO``: 1. SAML does not have a good update / deprovisioning story
* ``TODO``: 2. Presenting users with attributes is not implemented in spar, because:
* ``TODO``: 3. The SAML standard is very dated and has dubious security properties (``TODO``: dig up one of the many beautiful xml-dsig rants out there), should be considered legacy, and be used a little as possible.

``TODO``: So the recommended setup is SAML + SCIM, and Oauth + SCIM as soon as we have released the latter.

Corner cases
------------

``TODO``: Why can't i disable SSO once it's enabled? -> need implementing.  

``TODO``: In order for this to work, we need to double-check that no sso users are still active in this team.

``TODO``: Hundreds and hundreds of corner cases:

* ``TODO``: You can't auto-provision users if scim tokens exist.
* ``TODO``: What happens if a user is created with sso auto-provisioning, then a scim token is created, and the user is now under scim management?  (*probably* all sound and good.)
* ``TODO``: What happens if the last scim token is removed, and users are still under scim management?  (possibly a bug.)
* ``TODO``: ...

``TODO``: IDEA: This is the section that'll potentially be most valuable, but i think the way to proceed is to cover the general idea first, publish that, and then publish incremental progress on this advanced part of the manual as we make it.
