let chai = require("chai");
let chaiHttp = require("chai-http");
let webEndpoint = require("../app");

let should = chai.should();

chai.use(chaiHttp);

describe("Signature", () => {
  /*
   * Test the /ping route
   */
  describe("/GET health check", () => {
    it("it should return a string", (done) => {
      chai
        .request(webEndpoint)
        .get("/ping")
        .end((err, res) => {
          res.should.have.status(200);
          res.text.should.be.a("string");
          res.text.should.be.equal("ok");
        });
      done();
    });
  });
  /*
   * Test the /search route
   */
  describe("/GET elasticsearch query", () => {
    it("it should return an array", (done) => {
      chai
        .request(webEndpoint)
        .get("/search/fridge")
        .end((err, res) => {
          res.should.have.status(404);
          res.body.should.be
            .an("array")
            .that.does.include("no products found...");
        });
      done();
    });
  });
  /*
   * Test the / route
   */
  describe("/GET root", () => {
    it("it should return an html page", (done) => {
      chai
        .request(webEndpoint)
        .get("/index.html")
        .end((err, res) => {
          res.should.have.status(200);
          res.should.have.header("content-type", "text/html; charset=UTF-8");
        });
      done();
    });
  });
});
