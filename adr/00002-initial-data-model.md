# ADR-002: Initial data model

Date: 2025-07-18

## Status

Proposed

---

## Context

The Department for Education is developing a system to allow providers (users) to find placements that are made available by schools (users). The data model must support:

- Many-to-many relationships between users and organisations
- Expression of school placement preferences by academic year
- Organisation metadata (addresses, contacts, and administrative info)

### Key domain concepts:

- **Users** (teachers, provider staff, school staff, DfE staff)
- **Organisations** (schools and training providers)
- **Placement Preferences** (set up by schools, expresses the willingness/ability to host placements)
- **Academic Years** (placement context)
- **Subjects** (categorisation for placements)

---

## Decision

We have defined the initial domain model using the following entities:

## Entity Relationship Diagram (ERD)

This diagram represents our current understanding of the data models that will exist within this application.

There are a few things to bear in mind when reading this:

- This diagram attempts to bridge the gap between a 'high level' list of entities, and a 'low level' database schema. It sits somewhere in between.
- It is incomplete. As we continue developing our services, this diagram will undoubtedly change and grow.

```mermaid
erDiagram

  %% === Core time period model ===
  AcademicYear {
    uuid id PK "Primary key"
    string name "E.g. 2024–2025"
    date starts_on "Term start date"
    date ends_on "Term end date"
  }

  %% === User model and identity ===
  User {
    uuid id PK "Primary key"
    boolean admin "System admin toggle"
    string first_name "User’s first name"
    string last_name "User’s last name"
    string email_address "Used for sign-in and notifications"
    uuid dfe_sign_in_uid "External identity ID"
    datetime last_signed_in_at "Timestamp of last sign-in"
    uuid organisation_id FK "Legacy or default organisation"
    uuid current_organisation_id FK "Currently selected org"
  }

  %% === User to organisation association ===
  UserOrganisation {
    uuid id PK "Primary key"
    uuid organisation_id FK "Organisation the user is linked to"
    uuid user_id FK "User in the relationship"
  }

  %% Supports many-to-many relationship between users and organisations (e.g. MATs, school groups)

  %% === Organisation model ===
  Organisation {
    uuid id PK "Primary key"
    string name "School or provider name"
    string urn "Unique Reference Number"
    string ukprn "UK Provider Reference Number"
    string code "GIAS code"
    float longitude "Geo location (lon)"
    float latitude "Geo location (lat)"
    string email_address "Generic contact email"
    boolean school "Is a school"
    boolean provider "Is an ITT provider"
  }

  %% === Organisation metadata ===
  OrganisationDetail {
    uuid id PK
    uuid organisation_id FK "Linked organisation"
    string gias_stuff "Additional metadata from GIAS"
  }

  %% Holds additional metadata (e.g. GIAS data), keeping Organisation table lean

  OrganisationContact {
    uuid id PK
    string first_name "Contact’s first name"
    string last_name "Contact’s last name"
    string email_address "Contact’s email"
    string phone "Contact telephone number"
    string role "E.g. ‘Placement lead’"
    uuid organisation_id FK "Linked organisation"
  }
  %% For listing individual contacts at a school or provider — e.g. placement coordinators

  OrganisationAddress {
    uuid id PK
    string address_1 "Field for information about the address"
    string address_2 "Field for information about the address"
    string address_3 "Field for information about the address"
    string town "Town"
    string city "City"
    string county "County"
    string postcode "Postcode"
    uuid organisation_id FK "Linked organisation"
  }
  %% Postal addresses are modeled separately to allow normalisation and optional geocoding

  %% === School placement availability ===
  PlacementPreference {
    uuid id PK "Primary key"
    enum appetite "e.g. not_interested, interested, unsure"
    uuid organisation_id FK "Which school"
    uuid academic_year_id FK "Which academic year"
    uuid created_by FK "User who created it"
    jsonb placement_details "Structured JSON field for quantity of placements, additional notes. Should be strucured more definitively in the future."
  }
  %% A school’s declaration of whether and how they’re offering placements in a given academic year
  %% Appetite might be: "not_interested", "interested", or "unsure". Names to be defined in the future.
  %% `placement_details` is stored in JSONB to allow flexible structured fields

  %% === Subject taxonomy ===
  PlacementSubject {
    uuid id PK
    string name "E.g. Biology"
    string code "Unique code"
    enum phase "Primary, Secondary"
    uuid parent_subject_id FK "If part of a broader subject group e.g French is part of Modern foreign languages."
  }
  %% Accredited subjects are categorised by phase (e.g. "primary", "secondary") and support nesting

  %% === Relationships with comments ===
  OrganisationDetail |o--|| Organisation : "Each detail row belongs to one organisation"
  OrganisationAddress |o--|| Organisation : "Each address belongs to one organisation"
  OrganisationContact |o--|| Organisation : "Each contact belongs to one organisation"
  UserOrganisation }o--|| Organisation : "An organisation has many user links"
  UserOrganisation }o--|| User : "A user can belong to many organisations"
  PlacementPreference }o--|| Organisation : "Placement preference belongs to a school"
  PlacementPreference }o--|| AcademicYear : "Scoped to a specific academic year"
  PlacementPreference }o--|| User : "Created by a user"
```

#### `User`
Represents system users.
- Fields: `first_name`, `last_name`, `email_address`, `dfe_sign_in_uid`, `last_signed_in_at`
- Linked to organisations via `UserOrganisation`
- Tracks current context via `current_organisation_id`
- Sign in flow will be handled via DfE Sign-in API, using `dfe_sign_in_uid`
- Users may belong to multiple organisations (via join table), but one is active (current_organisation_id). This will allow users to maintain context between logins.

#### `Organisation`
Represents either a school or a provider via the school and provider booleans.
- Fields: `urn`, `ukprn`, `code`, `school`, `provider`, `longitude`, `latitude`, `email_address`
- Longitude and Latitude allow for distance based search between schools and providers via external API call. Providers may not want to assign trainees to schools too far away.

#### `UserOrganisation`
Join table supporting many-to-many user-organisation relationships.

#### `AcademicYear`
Defines placement periods with `starts_on` and `ends_on` dates.

#### `PlacementPreference`
Records whether and how a school is offering placements.
- Fields: `appetite` (enum), `placement_details` (JSONB), `created_by`
- Linked to `organisation`, `academic_year`, and `user`
- Use of a JSONB field allows flexibility in defining the placement preference. This is useful in the initial setup, but replacing this with a more structured model should be investigated in the future. 

#### `PlacementSubject`
Defines a hierarchical subject taxonomy.
- Fields: `name`, `code`, `phase` (enum), `parent_subject_id`
- Phase can be either "primary" or "secondary"

### Supporting Entities

#### `OrganisationAddress`, `OrganisationDetail`, `OrganisationContact`
Capture normalised organisation metadata:
- **Address**: postal fields
- **Detail**: GIAS data or other rich metadata
- **Contact**: named people linked to roles and contact info

---

## Consequences

- Modular structure makes it easy to evolve the model.
- JSONB usage in `placement_details` offers flexibility for future changes.
- Academic year scoping ensures placement data remains timely and relevant.
- `UserOrganisation` supports real-world user delegation patterns.

---

## Risks / Trade-offs

- JSONB fields are less queryable and less enforceable via database constraints.
- Geolocation data in `Organisation` may be inaccurate or stale without an API call to support it - if an institution moves location for example
- `PlacementSubject` hierarchy requires application-level constraints to avoid invalid trees (e.g. circular references).

---

## Next Steps

- Create migrations to instantiate the tables defined in the entity relationship diagram
- Define enums for `appetite` and `phase`.
- Seed `academic_years` and `placement_subjects`.
- Apply foreign key constraints across all relationship tables.

---