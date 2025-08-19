# 🧬 DNA Data Access Consent Contract

## 📌 What is this?

This smart contract provides a **secure, transparent, and trustless system** for managing **consent to access DNA/genomic data**.

⚠️ **Note**:  
The contract **never stores raw DNA data** on-chain. Instead, it stores **content references** such as IPFS hashes or encrypted blob identifiers.
 
### Core Features:
 
- 👤 **Subject-controlled DNA registration** — individuals register encrypted references to their DNA data.  
- ⏳ **Time-limited consent** — subjects can grant researchers access for a specific duration. 
- ❌ **Revoke anytime** — subjects can revoke researcher access immediately. 
- 🧾 **Audit log** — every action (DNA registration, consent granted/revoked) is permanently logged on-chain. 
- 🧑‍🔬 **Researcher registry** — researchers must register before they can be granted access.
- ✅ **Access check** — anyone can verify whether a researcher has valid permission.

---

## 🤔 Why is this important?

DNA/genomic data is **extremely sensitive**. If misused or exposed, it can reveal private information about a person’s health, family, and identity.

This contract solves the problem by ensuring:

1. **Ownership & Control**

   - The subject (data owner) is the **only person** who can grant/revoke access.
   - Researchers cannot bypass the owner’s consent.

2. **Privacy by Design**

   - No raw DNA is stored on-chain — only **encrypted references (hashes/IPFS CIDs)**.
   - Even if the contract is public, the actual genomic data remains off-chain and secure.

3. **Transparency & Trust**

   - All consent changes (grants/revokes) are **permanently recorded on-chain**.
   - Researchers and institutions can prove they had permission at a given time.

4. **Time-Limited Access**

   - Permissions **automatically expire** after a set duration.
   - Prevents indefinite usage of DNA data beyond what was agreed.

5. **Medical Research Enablement**
   - Allows researchers to access data **ethically and legally**.
   - Encourages people to share DNA for science without fear of misuse.

---

## 🔑 Example Flow

1. **DNA Subject** registers a DNA record (IPFS hash).
2. **Researcher** registers their profile (name + org).
3. Subject **grants access** to researcher for 90 days.
4. Anyone can call `hasAccess(dnaId, researcher)` to check validity.
5. Subject can **revoke access anytime**, or it expires automatically.

---

## 📜 License

MIT License © 2025

