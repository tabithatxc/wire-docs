


(sorry, this isn't really rst, i'm lazy.)



TODO: import or reference design.rst somehow.



TOC / TODO:


# introduction

Historically, wire has allowed team admins and owners to manage their users in the team settings app.  This does not scale...

solution: scim!  (what's this?)

Historically, wire user auth is via phone or password.  This has security implications: ...; and does not scale either: ...

solution: saml!  (future work: oauth)

wire comes with a backend module that provides saml single sign on and scim user provisioning for wire.  You're looking at the administrator's manual.


# saml sso

## terminology and concepts

- idp
- authentication request
- authentication response
- how does the auth flow work (see ./design.rst)
- [everything we discuss in https://docs.wire.com/how-to/single-sign-on/trouble-shooting.html, https://docs.wire.com/how-to/single-sign-on/index.html]
- [everything that comes to mind while writing this manual]

## idp management (in team settings or via curl)

create, read, update, delete in team-settings (some of it is not
implemented, also document the curl way for everything?)

deletion is tricky, but solved: the rest api end-point fails if the idp to be deleted is still authenticating active users in the team; but if you move all those users to other idps, you can delete it.  there is also a `force` query parameter in the delete end-point that removes all dangling users instead of failing.  what's to be decided is how to add that to team settings.  currently we need to fall back to the rest api for all this.


## authentication

this could be kind of the user's manual.  or a summary of the user's manual plus a link, if we have it elsewhere.  (TODO: talk to srikant and maybe astrid about the new documentation that's to replace support.wire.com, i heard rumors about that).


# scim user provisioning

## terminology and concepts

- scim peer (equivalent to idp)

## scim peer management (in team settings or via curl)

### scim security and authentication

we're using a very basic variant of oauth that just contains a header
with a bearer token in all scim requests.  the token is created in
team settings and added to your scim peer somehow (see howtos or below
(wherever we end up putting it) for azure, curl).


### CRUD in team settings

did we implement this fully?  i think we may have:
- we don't need the U in CRUD since we can just delete-and-recreate; and
- we have just enough R for it to be secure (never expose the token after it's been handed over to the admin).


## using scim with azure

we have a howto for saml, i think we'll need another one for scim.

## using scim via curl

see `wireapp/wire-server/docs/reference/provisioning/` on github.



# scim + sso

Using saml sso without scim is deprecated:

1. saml does not have a good update / deprovisioning story
2. presenting users with attributes is not implemented in spar, because:
3. the saml standard is very dated and has dubious security properties (TODO: dig up one of the many beautiful xml-dsig rants out there), should be considered legacy, and be used a little as possible.

so the recommended setup is saml + scim, and oauth + scim as soon as we have released the latter.


## corner cases

why can't i disable sso once it's enabled? -> need implementing.  in order for this to work, we need to double-check that no sso users are still active in this team.

hundrets and hundrets of corner cases:
- you can't auto-provision users if scim tokens exist.
- what happens if a user is created with sso auto-provisioning, then a scim token is created, and the user is now under scim management?  (*probably* all sound and good.)
- what happens if the last scim token is removed, and users are still under scim management?  (possibly a bug.)
- ...

IDEA: this is the section that'll potentially be most valuable, but i
think the way to proceed is to cover the general idea first, publish
that, and then publish incremental progress on this advanced part of
the manual as we make it.
