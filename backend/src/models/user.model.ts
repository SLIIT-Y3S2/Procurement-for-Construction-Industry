import mongoose from "mongoose";
import bcrypt from "bcrypt";
import { customAlphabet } from "nanoid";
const nanoid = customAlphabet("0123456789", 10);

// TODO add contact Number
export interface UserInput {
  email: string;
  name: string;
  password: string;
  role: "siteManager" | "companyManager" | "procurementStaff" | "supplier";
  contactNumber: string;
}

export interface UserDocument extends UserInput, mongoose.Document {
  userId: string;
  createdAt: Date;
  updatedAt: Date;
  comparePassword(candidatePassword: string): Promise<Boolean>;
}

const userSchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      required: true,
      unique: true,
      default: () => `U-${nanoid()}`,
    },
    email: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    password: { type: String, required: true },
    contactNumber: { type: String, required: true },
    role: {
      type: String,
      enum: ["siteManager", "companyManager", "procurementStaff", "supplier"],
      default: "siteManager",
    },
  },
  {
    timestamps: true,
  }
);

userSchema.pre("save", async function (next) {
  let user = this as UserDocument;

  if (!user.isModified("password")) {
    return next();
  }

  const salt = await bcrypt.genSalt(10);

  const hash = await bcrypt.hashSync(user.password, salt);

  user.password = hash;

  return next();
});

userSchema.methods.comparePassword = async function (
  candidatePassword: string
): Promise<boolean> {
  const user = this as UserDocument;

  return bcrypt.compare(candidatePassword, user.password).catch((e) => false);
};

const UserModel = mongoose.model<UserDocument>("User", userSchema);

export default UserModel;
