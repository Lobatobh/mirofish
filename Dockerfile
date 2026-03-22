# ===== FRONTEND BUILD =====
FROM node:18-alpine as frontend-build

WORKDIR /app
COPY frontend/ ./frontend/

WORKDIR /app/frontend
RUN npm install
RUN npm run build

# ===== BACKEND =====
FROM python:3.11-slim

WORKDIR /app

COPY backend/ ./backend/

RUN pip install --no-cache-dir flask gunicorn

# Copia frontend buildado
COPY --from=frontend-build /app/frontend/dist /app/backend/dist

WORKDIR /app/backend

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5001", "run:app"]  
