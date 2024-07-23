import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'Minha API',
    version: '1.0.0',
    description: 'Documentação da API',
  },
  servers: [
    {
      url: 'http://localhost:3000', // URL do seu servidor
      description: 'Servidor local',
    },
  ],
};

const options = {
  swaggerDefinition,
  apis: ['./index.js'], // Inclua o arquivo index onde suas rotas estão definidas
};

const specs = swaggerJsdoc(options);

export { swaggerUi, specs };




