
TODO: import or reference design.rst somehow.

TOC / TODO:

Introduction
============

Historically, wire has allowed team admins and owners to manage their users in the team settings app.  This does not scale...

Solution: SCIM! `(System for Cross-domain Identity Management) <https://en.wikipedia.org/wiki/System_for_Cross-domain_Identity_Management>`_ (what's this?)

Historically, wire user auth is via phone or password.  This has security implications: ...; and does not scale either: ...

Solution: SAML! `(Security Assertion Markup Language) <https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language>`_ (future work: Oauth)

Wire comes with a backend module that provides saml single sign on and scim user provisioning for wire.  You're looking at the administrator's manual.


SAML/SSO 
========

Terminology and concepts
------------------------

- IdP (https://en.wikipedia.org/wiki/Identity_provider)
- Authentication request
- Authentication response
- How does the auth flow work (see ./design.rst)
- [Everything we discuss in https://docs.wire.com/how-to/single-sign-on/trouble-shooting.html, https://docs.wire.com/how-to/single-sign-on/index.html]
- [Everything that comes to mind while writing this manual]

## IdP management (in team settings or via curl)

CRUD: Create, Read, Update, Delete in team-settings (some of it is not
implemented, also document the curl way for everything?)

Deletion is tricky, but solved: the rest api end-point fails if the idp to be deleted is still authenticating active users in the team; but if you move all those users to other IdPs, you can delete it.  

There is also a `force` query parameter in the delete end-point that removes all dangling users instead of failing.  

What's to be decided is how to add that to team settings. 

Currently we need to fall back to the rest api for all this.


Authentication
--------------

This could be kind of the user's manual.

Or a summary of the user's manual plus a link, if we have it elsewhere. 

(TODO: talk to srikant and maybe astrid about the new documentation that's to replace support.wire.com, i heard rumors about that).


SCIM user provisioning
======================

Terminology and concepts
------------------------

- SCIM peer (equivalent to IdP)

SCIM peer management (in team settings or via curl)
---------------------------------------------------

SCIM security and authentication
................................

We're using a very basic variant of oauth that just contains a header with a bearer token in all SCIM requests. 

The token is created in team settings and added to your scim peer somehow (see howtos or below (wherever we end up putting it) for Azure, curl).

CRUD in team settings
.....................

Did we implement this fully? I think we may have:

- We don't need the U in CRUD since we can just delete-and-recreate; and
- We have just enough R for it to be secure (never expose the token after it's been handed over to the admin).

Using SCIM with azure
---------------------

We have a howto for SAML i think we'll need another one for SCIM.

Using SCIM via curl
-------------------

See `wireapp/wire-server/docs/reference/provisioning/` on github.

SCIM + SSO 
==========

Using SAML SSO without SCIM is deprecated:

1. SAML does not have a good update / deprovisioning story
2. Presenting users with attributes is not implemented in spar, because:
3. The SAML standard is very dated and has dubious security properties (TODO: dig up one of the many beautiful xml-dsig rants out there), should be considered legacy, and be used a little as possible.

So the recommended setup is SAML + SCIM, and Oauth + SCIM as soon as we have released the latter.

Corner cases
------------

Why can't i disable SSO once it's enabled? -> need implementing.  

In order for this to work, we need to double-check that no sso users are still active in this team.

Hundreds and hundreds of corner cases:
- You can't auto-provision users if scim tokens exist.
- What happens if a user is created with sso auto-provisioning, then a scim token is created, and the user is now under scim management?  (*probably* all sound and good.)
- What happens if the last scim token is removed, and users are still under scim management?  (possibly a bug.)
- ...

IDEA: This is the section that'll potentially be most valuable, but i think the way to proceed is to cover the general idea first, publish that, and then publish incremental progress on this advanced part of the manual as we make it.
