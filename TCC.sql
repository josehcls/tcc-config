CREATE SCHEMA "user";
CREATE SCHEMA "recipe";
CREATE SCHEMA "control";

CREATE TABLE "user"."users" (
  "user_id" SERIAL PRIMARY KEY,
  "username" varchar(128),
  "email" varchar(128),
  "password" varchar(128),
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "user"."users" (username);
create index on "user"."users" (email);

CREATE TABLE "user"."devices" (
  "device_id" SERIAL PRIMARY KEY,
  "model" varchar(128),
  "version" varchar(128),
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "user"."user_devices" (
  "user_device_id" SERIAL PRIMARY KEY,
  "user_id" int,
  "device_id" int,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "user"."user_devices" (user_id);
create index on "user"."user_devices" (device_id);

CREATE TABLE "recipe"."recipes" (
  "recipe_id" SERIAL PRIMARY KEY,
  "name" varchar(128),
  "style" varchar(128),
  "misc" text,
  "created_by" int,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "recipe"."recipes" (created_by);
create index on "recipe"."recipes" (name);
create index on "recipe"."recipes" (style);

CREATE TABLE "control"."control_profiles" (
  "control_profile_id" SERIAL PRIMARY KEY,
  "name" varchar(128),
  "created_by" int,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "control"."control_profiles" (name);
create index on "control"."control_profiles" (created_by);

CREATE TABLE "control"."control_profile_steps" (
  "control_profile_step_id" SERIAL PRIMARY KEY,
  "control_profile_id" int,
  "step" int,
  "variable" varchar(32),
  "value" decimal,
  "time_offset" bigint,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "control"."control_profile_steps" (control_profile_id);

CREATE TABLE "recipe"."batches" (
  "batch_id" SERIAL PRIMARY KEY,
  "name" varchar(128),
  "recipe_id" int,
  "status" varchar(32),
  "started_at" timestamp,
  "finished_at" timestamp,
  "misc" text,
  "created_by" int,
  "control_profile_id" int,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "recipe"."batches" (name);
create index on "recipe"."batches" (recipe_id);
create index on "recipe"."batches" (created_by);
create index on "recipe"."batches" (control_profile_id);

CREATE TABLE "recipe"."device_batches" (
  "device_batch_id" SERIAL PRIMARY KEY,
  "batch_id" int,
  "device_id" int,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "recipe"."device_batches" (batch_id);
create index on "recipe"."device_batches" (device_id);
create index on "recipe"."device_batches" (status);

CREATE TABLE "recipe"."batch_datapoints" (
  "batch_datapoint_id" SERIAL PRIMARY KEY,
  "batch_id" int,
  "variable" varchar(32),
  "value" decimal,
  "moment" timestamp,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "recipe"."batch_datapoints" (batch_id);

CREATE TABLE "recipe"."batch_custom_datapoints" (
  "batch_custom_datapoint_id" SERIAL PRIMARY KEY,
  "batch_id" int,
  "variable" varchar(32),
  "value" decimal,
  "moment" timestamp,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);
create index on "recipe"."batch_custom_datapoints" (batch_id);

ALTER TABLE "user"."user_devices" ADD FOREIGN KEY ("user_id") REFERENCES "user"."users" ("user_id");

ALTER TABLE "user"."user_devices" ADD FOREIGN KEY ("device_id") REFERENCES "user"."devices" ("device_id");

ALTER TABLE "recipe"."recipes" ADD FOREIGN KEY ("created_by") REFERENCES "user"."users" ("user_id");

ALTER TABLE "control"."control_profiles" ADD FOREIGN KEY ("created_by") REFERENCES "user"."users" ("user_id");

ALTER TABLE "control"."control_profile_steps" ADD FOREIGN KEY ("control_profile_id") REFERENCES "control"."control_profiles" ("control_profile_id");

ALTER TABLE "recipe"."batches" ADD FOREIGN KEY ("recipe_id") REFERENCES "recipe"."recipes" ("recipe_id");

ALTER TABLE "recipe"."batches" ADD FOREIGN KEY ("created_by") REFERENCES "user"."users" ("user_id");

ALTER TABLE "recipe"."batches" ADD FOREIGN KEY ("control_profile_id") REFERENCES "control"."control_profiles" ("control_profile_id");

ALTER TABLE "recipe"."device_batches" ADD FOREIGN KEY ("batch_id") REFERENCES "recipe"."batches" ("batch_id");

ALTER TABLE "recipe"."device_batches" ADD FOREIGN KEY ("device_id") REFERENCES "user"."devices" ("device_id");

ALTER TABLE "recipe"."batch_datapoints" ADD FOREIGN KEY ("batch_id") REFERENCES "recipe"."batches" ("batch_id");

ALTER TABLE "recipe"."batch_custom_datapoints" ADD FOREIGN KEY ("batch_id") REFERENCES "recipe"."batches" ("batch_id");
